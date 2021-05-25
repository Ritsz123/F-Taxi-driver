import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_driver_app/globals.dart';
import 'package:uber_driver_app/screens/homeScreen.dart';
import 'package:uber_driver_app/widgets/progressIndicator.dart';
import 'package:uber_driver_app/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';

class VehicleInfoScreen extends StatelessWidget {
  static final id = "vehicleInfoScreen";

  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();
  final TextEditingController carRegistrationController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void updateVehicleDetailsInDB(context) async {
    ProgressDialog(status: 'please wait..');
    String id = currentFirebaseUser!.uid;
    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/$id/vehicle_details');
    Map map = {
      'car_color': carColorController.text,
      'car_model': carModelController.text,
      'vehicle_number': carRegistrationController.text,
    };

    await driverRef.set(map);
    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
  }

  void showSnackBar(BuildContext context, String title) {
    final snackBar = SnackBar(
      elevation: 10,
      content: title.text.size(15).make(),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              30.heightBox,
              Image.asset(
                'assets/images/logo.png',
                height: 110,
                width: 110,
              ),
              10.heightBox,
              "Enter vehicle Details".text.xl2.fontFamily('Brand-Bold').make(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  children: [
                    TextField(
                      controller: carModelController,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        hintText: "Car Model",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    10.heightBox,
                    TextField(
                      controller: carColorController,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        hintText: "Car Color",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    10.heightBox,
                    TextField(
                      controller: carRegistrationController,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        hintText: "Vehicle registration number",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    30.heightBox,
                    TaxiButton(
                        onPressed: () {
                          if (carColorController.text.length < 3) {
                            showSnackBar(context, 'please provide valid car color');
                            return;
                          }
                          if (carModelController.text.length < 3) {
                            showSnackBar(context, 'please provide valid car model');
                            return;
                          }
                          if (carRegistrationController.text.length < 3) {
                            showSnackBar(context,
                                'please provide valid car registration number');
                            return;
                          }
                          updateVehicleDetailsInDB(context);
                        },
                        buttonText: 'Proceed'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
