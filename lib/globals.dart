import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

User? currentFirebaseUser;

Logger logger = Logger();

final CameraPosition googlePlex = CameraPosition(
  bearing: 0,
  target: LatLng(28.6139, 77.2090),
  tilt: 0,
  zoom: 3,
);

StreamSubscription<Position>? homeTabPositionStream;
