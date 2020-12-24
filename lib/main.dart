import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uber_driver_app/screens/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final FirebaseApp app = await Firebase.initializeApp(
      name: 'db2',
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
  } catch (ex) {
    print(ex.toString());
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomePage.id,
      routes: {
        HomePage.id: (context) => HomePage(),
      },
    );
  }
}
