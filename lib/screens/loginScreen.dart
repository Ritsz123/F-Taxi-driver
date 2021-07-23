import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:uber_driver_app/Colors.dart';
import 'package:uber_driver_app/globals.dart';
import 'package:uber_driver_app/screens/registrationScreen.dart';
import 'package:uber_driver_app/widgets/input_field.dart';
import 'package:uber_driver_app/widgets/progressIndicator.dart';
import 'package:uber_driver_app/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "loginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String _email = '';
  String _password = '';

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
              70.heightBox,
              Image(
                alignment: Alignment.center,
                height: 100,
                width: 100,
                image: AssetImage("assets/images/logo.png"),
              ),
              20.heightBox,
              "Sign in as a Driver".text.size(25).fontFamily('Brand-Bold').make(),
              20.heightBox,
              Column(
                children: [
                  _loginForm(),
                  40.heightBox,
                  TaxiButton(
                    onPressed: processLogin,
                    buttonText: "login",
                    color: MyColors.colorAccentPurple,
                  ),
                ],
              ).p24(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.id, (route) => false);
                },
                child:
                  "Don't have a account, sign up here".text.size(15).make(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Column(
      children: [
        InputField(
          labelText: 'Email Address',
          onValueChange: (String value) {
            _email = value;
          },
          keyboardType: TextInputType.emailAddress,
        ),
        10.heightBox,
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

  Future<bool> _validateLoginForm() async {
    var connResult = await Connectivity().checkConnectivity();
    if (connResult != ConnectivityResult.mobile &&
        connResult != ConnectivityResult.wifi) {
      showSnackBar("No Internet connectivity");
      return false;
    }

    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)){
      showSnackBar('Invalid email');
      return false;
    }else if (_password.length < 6) {
      showSnackBar("please enter valid password");
      return false;
    }
    return true;
  }

  void processLogin() async {
    bool isFormValid = await _validateLoginForm();
    if(!isFormValid) return;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ProgressDialog(status: "Logging you in..."),
    );

    logger.i('making login request');
    /*

    try {
      Map<String, dynamic> response = await RequestHelper.postRequest(
        url: serviceUrl.loginUser,
        body: {
          'email' : _email,
          'password' : _password,
        },
      );

      String authToken = response['body']['token'];
      bool cached = await HelperMethods.cacheAuthToken(authToken);
      if(cached) {
        Provider.of<AppData>(context, listen: false).setAuthToken(authToken);

        logger.i('Login Successful');

        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
      }
    } catch (e) {
      Navigator.pop(context);
      showSnackBar(e.toString());
    }

    */
  }
}
