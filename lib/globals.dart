import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

User? currentFirebaseUser;

final CameraPosition googlePlex = CameraPosition(
  bearing: 192.8334901395799,
  target: LatLng(37.43296265331129, -122.08832357078792),
  tilt: 59.440717697143555,
  zoom: 19.151926040649414,
);

StreamSubscription<Position>? homeTabPositionStream;
