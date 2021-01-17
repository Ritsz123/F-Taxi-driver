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

  void getLocationUpdates() {
    homeTabPositionStream = Geolocator.getPositionStream(
      distanceFilter: 4,
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    ).listen((Position position) {
      currentPosition = position;
      Geofire.setLocation(
        currentFirebaseUser.uid,
        currentPosition.latitude,
        currentPosition.longitude,
      );
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
            buttonText: "Go online",
            color: Color(0xff159f15),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => ConfirmSheet(),
                isDismissible: false,
              );
//              goOnline();
//              getLocationUpdates();
            },
          ),
        ),
      ],
    );
  }
}
