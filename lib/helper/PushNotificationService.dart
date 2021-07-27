import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uber_driver_app/models/AddressModel.dart';

import '../globals.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.i('Got message from FCM');

      Map<String, dynamic> messageData = message.data;
      String rideId = messageData['rideId'];
      // logger.i('ride Id: $rideId');

      fetchRideInfo(rideId);
    });
    
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('On message Opened : $message');
    });
  }

  Future<String?> getToken() async {
    String? fcmToken = await fcm.getToken();
    logger.i('FCM token : $fcmToken');
    //TODO create api to update token in db
    // DatabaseReference tokenRef =
    //     FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser!.uid}/token');
    // tokenRef.set(token);

    fcm.subscribeToTopic('allDrivers');
    fcm.subscribeToTopic('allUsers');
    return fcmToken;
  }

  void fetchRideInfo(String rideId) {
    DatabaseReference rideRef = FirebaseDatabase.instance.reference().child('rideRequest/$rideId');
    
    rideRef.once().then((DataSnapshot snapshot) {
      if(snapshot.value != null) {
        Address pickupAddress = Address(
          placeName: snapshot.value['pickupAddress']['placeName'],
          latitude: snapshot.value['pickupAddress']['latitude'],
          longitude: snapshot.value['pickupAddress']['longitude'],
        );

        logger.i('pickup ${pickupAddress.toString()}');
      }
    });
  }
}
