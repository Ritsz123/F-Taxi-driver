import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/Colors.dart';
import 'package:uber_driver_app/dataProvider/AppData.dart';
import 'package:uber_driver_app/globals.dart';
import 'package:uber_driver_app/helper/PushNotificationService.dart';
import 'package:uber_driver_app/helper/request_helper.dart';
import 'package:uber_driver_app/models/userModel.dart';
import 'package:uber_driver_app/widgets/confirmSheet.dart';
import 'package:uber_driver_app/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:uber_driver_app/serviceUrls.dart' as serviceUrl;

import '../globals.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late GoogleMapController _mapController;
  Completer<GoogleMapController> _controller = Completer();
  late Position currentPosition;
  String availableDriversPathInDB = "driversAvailable";
  DatabaseReference? tripRequestRef;
  bool isOnline = false;
  String availabilityText = "GO Online";
  Color availabilityColor = MyColors.colorLightGreen;
  String goOnlineDesc = "Are you sure you want to go Online and start receiving trip requests ?";
  String goOfflineDesc = "Are you sure you want to go Offline and stop receiving all trip requests ?";
  late UserModel currentUser;
  String? token;


  @override
  void initState() {
    super.initState();
    token = Provider.of<AppData>(context, listen: false).getAuthToken();
    getCurrentDriverInfo();
  }

  void getCurrentDriverInfo() async {
    String url = serviceUrl.getUserData;
    try {
      Map<String, dynamic> response = await RequestHelper.getRequest(
        url: url,
        withAuthToken: true,
        token: token,
      );

      UserModel model = UserModel.fromJson(response['body']);
      Provider.of<AppData>(context, listen: false).setCurrentUser(model);
      logger.i('get current user info success');

      PushNotificationService notificationService = PushNotificationService();
      notificationService.initialize();
      notificationService.getToken();
    } catch(e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 135),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _mapController = controller;
            getCurrentLocation();
          },
          initialCameraPosition: googlePlex,
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: MyColors.colorPrimary,
        ),
        Positioned(
          top: 60,
          right: context.screenWidth / 4,
          left: context.screenWidth / 4,
          child: TaxiButton(
            textSize: 20,
            buttonText: availabilityText,
            color: availabilityColor,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _changeAvailabilityConfirmDialog(),
                isDismissible: false,
              );
            },
          ),
        ),
      ],
    );
  }

  void getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location Services disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      print("Location services denied forever");
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        print("denied");
        return;
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    _mapController.animateCamera(CameraUpdate.newLatLng(pos));
    CameraPosition cp = CameraPosition(
      target: pos,
      zoom: 16,
    );
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(cp),
    );
  }

  Widget _changeAvailabilityConfirmDialog() {
    return ConfirmSheet(
      isOnline: isOnline,
      title: isOnline ? "Go offline" : "go online",
      subTitle: isOnline ? goOfflineDesc : goOnlineDesc,
      onPressed: () {
        if (isOnline) {
          //go offline
          goOffline();
          setState(() {
            isOnline = false;
            availabilityColor = MyColors.colorLightGreen;
            availabilityText = "GO online";
          });
        } else {
          //go online
          goOnline();
          getLocationUpdates();
          setState(() {
            isOnline = true;
            availabilityColor = MyColors.colorRed;
            availabilityText = "GO offline";
          });
        }
        //remove confirmation sheet
        Navigator.pop(context);
      },
    );
  }

  void goOnline() {
    currentUser = Provider.of<AppData>(context, listen: false).getCurrentUser();

    Geofire.initialize(availableDriversPathInDB);
    Geofire.setLocation(
      currentUser.id,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    // tripRequestRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser!.uid}/newtrip');
    // tripRequestRef!.set('waiting');
    // tripRequestRef!.onValue.listen((event) {
    //   print(event.snapshot.value);
    // });
  }

  void getLocationUpdates() {
    homeTabPositionStream = Geolocator.getPositionStream(
      distanceFilter: 4,
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    ).listen((Position position) {
      currentPosition = position;
      if (isOnline) {
        Geofire.setLocation(
          currentUser.id,
          currentPosition.latitude,
          currentPosition.longitude,
        );
      }
      LatLng pos = new LatLng(currentPosition.latitude, currentPosition.longitude);
      _mapController.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }

  void goOffline() {
    Geofire.removeLocation(currentUser.id);
    // tripRequestRef!.onDisconnect();
    // tripRequestRef!.remove();
    // tripRequestRef = null;
  }
}
