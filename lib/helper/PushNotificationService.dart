import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../globals.dart';

class PushNotificationService {
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Message : $message');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('On message Opened : $message');
    });
  }

  Future<String?> getToken() async {
    String? token = await fcm.getToken();
    print('token : $token');
    DatabaseReference tokenRef =
        FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser!.uid}/token');
    tokenRef.set(token);

    fcm.subscribeToTopic('allDrivers');
    fcm.subscribeToTopic('allUsers');
    return token;
  }
}
