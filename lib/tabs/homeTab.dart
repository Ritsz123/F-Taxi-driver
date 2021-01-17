import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_driver_app/Colors.dart';
import 'package:uber_driver_app/globals.dart';
import 'package:uber_driver_app/widgets/availabilityButton.dart';
import 'package:uber_driver_app/widgets/confirmSheet.dart';
import 'package:uber_driver_app/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController _mapController;
  Completer<GoogleMapController> _controller = Completer();
  Position currentPosition;
  String availableDriversPathInDB = "driversAvailable";
  DatabaseReference tripRequestRef;
  bool isOnline = false;
  String availabilityText = "GO Online";
  Color availabilityColor = MyColors.colorLightGreen;
  String goOnlineDesc =
      "Are you sure you want to go Online and start receiving trip requests ?";
  String goOfflineDesc =
      "Are you sure you want to go Offline and stop receiving all trip requests ?";

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
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
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
  }

  void goOnline() {
    Geofire.initialize(availableDriversPathInDB);
    Geofire.setLocation(
      currentFirebaseUser.uid,
      currentPosition.latitude,
      currentPosition.longitude,
    );
    tripRequestRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser.uid}/newtrip');
    tripRequestRef.set('waiting');
    tripRequestRef.onValue.listen((event) {
      print(event.snapshot.value);
    });
  }

  void goOffline() {
    Geofire.removeLocation(currentFirebaseUser.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;
  }

  void getLocationUpdates() {
    homeTabPositionStream = Geolocator.getPositionStream(
      distanceFilter: 4,
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    ).listen((Position position) {
      currentPosition = position;
      if (isOnline) {
        Geofire.setLocation(
          currentFirebaseUser.uid,
          currentPosition.latitude,
          currentPosition.longitude,
        );
      }
      LatLng pos =
          new LatLng(currentPosition.latitude, currentPosition.longitude);
      _mapController.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 135),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.terrain,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete();
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
                builder: (context) => ConfirmSheet(
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
                ),
                isDismissible: false,
              );
            },
          ),
        ),
      ],
    );
  }
}
