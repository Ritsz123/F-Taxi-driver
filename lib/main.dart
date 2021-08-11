import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/dataProvider/AppData.dart';
import 'package:uber_driver_app/screens/homeScreen.dart';
import 'package:uber_driver_app/screens/loginScreen.dart';
import 'package:uber_driver_app/screens/registrationScreen.dart';
import 'package:uber_driver_app/screens/vehicleInfoScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final FirebaseApp app = await Firebase.initializeApp();
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
        initialRoute: true? LoginScreen.id : HomeScreen.id,
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
