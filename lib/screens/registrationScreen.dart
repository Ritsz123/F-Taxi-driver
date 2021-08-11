import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/Colors.dart';
import 'package:uber_driver_app/dataProvider/AppData.dart';
import 'package:uber_driver_app/globals.dart';
import 'package:uber_driver_app/helper/HelperMethods.dart';
import 'package:uber_driver_app/helper/request_helper.dart';
import 'package:uber_driver_app/screens/loginScreen.dart';
import 'package:uber_driver_app/screens/vehicleInfoScreen.dart';
import 'package:uber_driver_app/widgets/input_field.dart';
import 'package:uber_driver_app/widgets/progressIndicator.dart';
import 'package:uber_driver_app/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:connectivity/connectivity.dart';
import 'package:uber_driver_app/serviceUrls.dart' as serviceUrl;

class RegistrationScreen extends StatefulWidget {
  static const String id = "registrationScreen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String _name = '';
  String _email = '';
  String _password = '';
  String _phone = '';
  bool isLoading = false;

  void showSnackBar(String title) {
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
            children: [
              50.heightBox,
              Image(
                alignment: Alignment.center,
                height: 100,
                width: 100,
                image: AssetImage("assets/images/logo.png"),
              ),
              20.heightBox,
              "Create a Driver's account".text.size(25).fontFamily('Brand-Bold').make(),
              15.heightBox,
              Column(
                children: [
                  _registrationForm(),
                  30.heightBox,
                  TaxiButton(
                    onPressed: registerUser,
                    buttonText: "Register",
                    color: MyColors.colorAccentPurple,
                  ),
                ],
              ).p24(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
                },
                child: "Already have a account?, Login".text.size(15).make(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registrationForm() {
    return Column(
      children: [
        InputField(
          labelText: 'Full name',
          onValueChange: (String value) {
            _name = value;
          },
        ),
        5.heightBox,
        InputField(
          labelText: 'Email Address',
          keyboardType: TextInputType.emailAddress,
          onValueChange: (String value) {
            _email = value;
          },
        ),
        5.heightBox,
        InputField(
          labelText: 'Phone number',
          keyboardType: TextInputType.number,
          onValueChange: (String value){
            _phone = value;
          },
        ),
        5.heightBox,
        InputField(
          labelText: 'Password',
          obscureText: true,
          onValueChange: (String value) {
            _password = value;
          },
        ),
      ],
    );
  }

  Future<bool> validateRegistration() async {
//   check network connection
    var connResult = await Connectivity().checkConnectivity();
    if (connResult != ConnectivityResult.mobile &&
        connResult != ConnectivityResult.wifi) {
      showSnackBar("No Internet connectivity");
      return false;
    }
    if (_name.length < 5) {
      showSnackBar("Please provide valid full name");
      return false;
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)) {
      showSnackBar("please provide valid email address");
      return false;
    } else if (_phone.length != 10) {
      showSnackBar("Please provide valid phone number");
      return false;
    }  else if (_password.length < 6) {
      showSnackBar("password length should be more than 6 characters");
      return false;
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ProgressDialog(status: "Registering user...."),
      );
    }
    return true;
  }

  void registerUser() async {
    final bool isFormValid = await validateRegistration();
    if(!isFormValid) return;

    try {
      String url = serviceUrl.registerDriver;
      Map<String, dynamic> response = await RequestHelper.postRequest(
        url: url,
        body: {
          'name': _name,
          'phone': _phone,
          'email': _email,
          'password': _password,
        },
      );

      String authToken = response['body']['token'];
      bool cached = await HelperMethods.cacheAuthToken(authToken);

      if(cached) {
        Provider.of<AppData>(context, listen: false).setAuthToken(authToken);
      }

      logger.i('User Registration Successful');

      Navigator.pushNamedAndRemoveUntil(context, VehicleInfoScreen.id, (route) => false);

    } catch (e) {
      Navigator.pop(context);
      showSnackBar(e.toString());
    }
  }
}
