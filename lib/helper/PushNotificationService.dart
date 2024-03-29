import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/dataProvider/AppData.dart';
import 'package:uber_driver_app/helper/request_helper.dart';
import 'package:uber_driver_app/models/AddressModel.dart';
import 'package:uber_driver_app/models/TripModel.dart';
import 'package:uber_driver_app/models/userModel.dart';
import 'package:uber_driver_app/widgets/progressIndicator.dart';
import 'package:uber_driver_app/widgets/tripRequestDialog.dart';
import '../globals.dart';
import 'package:uber_driver_app/serviceUrls.dart' as serviceUrl;

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  final String authToken;

  PushNotificationService({required this.authToken});

  Future<void> initialize(BuildContext context) async {
    logger.e('initializing FCM');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.i('got a fcm message');

      Map<String, dynamic> messageData = message.data;

      logger.i(messageData);

      fetchRideInfo(messageData['rideId'], context);

    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      logger.i('got a fcm background message');

      Map<String, dynamic> messageData = message.data;

      fetchRideInfo(messageData['rideId'], context);

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('On message Opened : $message');

    });
  }

  Future<String?> getToken() async {
    try{
      String? fcmToken = await fcm.getToken();
      logger.i('FCM token : $fcmToken');

      final String url = serviceUrl.updateFcmToken;

      RequestHelper.putRequest(
        url: url,
        body: {
          'fcmToken': fcmToken
        },
        token: authToken,
      );

      fcm.subscribeToTopic('allDrivers');
      fcm.subscribeToTopic('allUsers');
      return fcmToken;
    } catch(e){
      logger.e(e);
    }
  }

  Address _addressFromMap(Map<String, dynamic> map) {
    return Address(
      placeName: map['placeName'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  Future<UserModel?> _fetchRiderInfo(String riderID, BuildContext context) async {
    String url = serviceUrl.getUserData + '/$riderID';
    try {
      Map<String, dynamic> response = await RequestHelper.getRequest(
        url: url,
        withAuthToken: true,
        token: authToken,
      );

      UserModel model = UserModel.fromJson(response['body']);
      return model;
    } catch(e) {
      logger.e(e);
    }
  }
  
  void fetchRideInfo(String tripId, BuildContext context) {

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ProgressDialog(status: "please wait.."),
    );

    DatabaseReference rideRef = FirebaseDatabase.instance.reference().child('rideRequest/$tripId');
    
    rideRef.once().then((DataSnapshot snapshot) async {
      if(snapshot.value != null) {
        final Address pickupAddress = _addressFromMap(Map<String, dynamic>.from(snapshot.value['pickupAddress']));
        final Address destAddress = _addressFromMap(Map<String, dynamic>.from(snapshot.value['destinationAddress']));
        final String paymentMethod = snapshot.value['paymentMethod'];
        final String riderID = snapshot.value['riderId'];
        UserModel? rider = await _fetchRiderInfo(riderID, context);

        Navigator.pop(context);

        if(rider != null){
          TripModel tripModel = TripModel(
            id: tripId,
            rider: rider,
            driver: Provider.of<AppData>(context, listen: false).getCurrentUser(),
            pickupAddress: pickupAddress,
            destAddress: destAddress,
            paymentMethod: paymentMethod,
          );

          logger.i('information retrived $tripModel');

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => TripRequestDialog(tripModel: tripModel),
          );
        } else{
          logger.e('Rider is null');
          throw Exception('Rider is null');
        }
      }
    });
  }
}
