import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/dataProvider/AppData.dart';
import 'package:uber_driver_app/helper/request_helper.dart';
import 'package:uber_driver_app/models/userModel.dart';
import 'package:uber_driver_app/screens/homeScreen.dart';
import 'package:uber_driver_app/widgets/input_field.dart';
import 'package:uber_driver_app/widgets/progressIndicator.dart';
import 'package:uber_driver_app/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:uber_driver_app/serviceUrls.dart' as serviceUrl;

class VehicleInfoScreen extends StatefulWidget {
  static final id = "vehicleInfoScreen";

  @override
  _VehicleInfoScreenState createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String _carModel = '';
  String _carColor = '';
  String _carRegNumber = '';

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
                    _vehicleDetailsForm(),
                    30.heightBox,
                    TaxiButton(
                      onPressed: () => updateVehicleDetailsInDB(context),
                      buttonText: 'Proceed',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vehicleDetailsForm() {
    return Column(
      children: [
        InputField(
          labelText: 'Car Model',
          onValueChange: (String value) {
            _carModel = value;
          },
        ),
        10.heightBox,
        InputField(
          labelText: 'Car Color',
          onValueChange: (String value){
            _carColor = value;
          },
        ),
        10.heightBox,
        InputField(
          labelText: 'Vehicle registration number',
          onValueChange: (String value) {
            _carRegNumber = value;
          },
        ),
      ],
    );
  }

  bool _validateVehicleDetails(BuildContext context){
    if (_carColor.length < 3) {
      showSnackBar(context, 'please provide valid car color');
      return false;
    }
    if (_carModel.length < 3) {
      showSnackBar(context, 'please provide valid car model');
      return false;
    }
    if (_carRegNumber.length < 3) {
      showSnackBar(context, 'please provide valid car registration number');
      return false;
    }
    return true;
  }

  void updateVehicleDetailsInDB(context) async {

    bool isFormValid = _validateVehicleDetails(context);
    if(!isFormValid) return;

    ProgressDialog(status: 'please wait..');

    try {
      String token = Provider.of<AppData>(context, listen: false).getAuthToken();
      String url = serviceUrl.updateVehicle;
      Map<String, dynamic> response = await RequestHelper.putRequest(
        url: url,
        token: token,
        body: {
          'reg_number': _carRegNumber,
          'model': _carModel,
          'color': _carColor
        },
      );

      UserModel model = UserModel.fromJson(response['body']);
      Provider.of<AppData>(context, listen: false).setCurrentUser(model);

      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
