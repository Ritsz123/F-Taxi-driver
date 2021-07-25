import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/dataProvider/AppData.dart';
import 'package:uber_driver_app/globals.dart';
import 'package:uber_driver_app/screens/homeScreen.dart';
import 'package:uber_driver_app/screens/loginScreen.dart';
import 'package:uber_driver_app/screens/registrationScreen.dart';
import 'package:uber_driver_app/screens/vehicleInfoScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final FirebaseApp app = await Firebase.initializeApp(
      name: 'db2',
      //TODO:Configure IOS app
      options: Platform.isIOS || Platform.isMacOS
//    for ios
          ? FirebaseOptions(
              appId: '1:297855924061:ios:c6de2b69b03a5be8',
              apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
              projectId: 'flutter-firebase-plugins',
              messagingSenderId: '297855924061',
              databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
            )
//    for android
          : FirebaseOptions(
              appId: '1:532235138800:android:f212e2ccac97bdc6423435',
              apiKey: 'AIzaSyBGFnI2gX1UKFf3XWBo6uUGCE0HhxKzMlo',
              messagingSenderId: '532235138800',
              projectId: 'riteshvk.uber_clone_driver',
              databaseURL: 'https://uber-clone-ba3b4.firebaseio.com',
            ),
    );
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
  } catch (ex) {
    print(ex.toString());
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute:
            currentFirebaseUser == null ? LoginScreen.id : HomeScreen.id,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          VehicleInfoScreen.id: (context) => VehicleInfoScreen(),
        },
      ),
    );
  }
}
