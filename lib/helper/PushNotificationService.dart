import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../globals.dart';

class PushNotificationService {
  FirebaseMessaging fcm = FirebaseMessaging();

  Future<void> initialize() async {
    fcm.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on Launch $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
    );
  }

  Future<String> getToken() async {
    String token = await fcm.getToken();
    print('token : $token');
    DatabaseReference tokenRef =
        FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/token');
    tokenRef.set(token);

    fcm.subscribeToTopic('allDrivers');
    fcm.subscribeToTopic('allUsers');
    return token;
  }
}
