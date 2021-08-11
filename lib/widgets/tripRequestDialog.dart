import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_driver_app/dataProvider/AppData.dart';
import 'package:uber_driver_app/globals.dart';
import 'package:uber_driver_app/helper/request_helper.dart';
import 'package:uber_driver_app/models/TripModel.dart';
import 'package:uber_driver_app/widgets/progressIndicator.dart';
import 'package:uber_driver_app/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:uber_driver_app/serviceUrls.dart' as serviceUrls;

class TripRequestDialog extends StatelessWidget {
  final TripModel tripModel;

  TripRequestDialog({Key? key, required this.tripModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 18,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.asset('assets/images/taxi.png', height: 150, width: 150, fit: BoxFit.contain,),
            ),
            'New Trip Request'.text.xl2.bold.makeCentered(),
            10.heightBox,
            Row(
              children: [
                Image.asset(
                  'assets/images/pickicon.png',
                  width: 20,
                  height: 20,
                ),
                20.widthBox,
                Expanded(child: tripModel.pickupAddress.placeName.text.xl.make()),
              ],
            ),
            5.heightBox,
            "to".text.bold.xl.makeCentered(),
            5.heightBox,
            Row(
              children: [
                Image.asset(
                  'assets/images/desticon.png',
                  width: 20,
                  height: 20,
                ),
                20.widthBox,
                Expanded(child: tripModel.destAddress.placeName.text.xl.make()),
              ],
            ),
            20.heightBox,
            VxDivider(width: 2),
            20.heightBox,
            Row(
              children: [
                Expanded(
                  child: TaxiButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.red,
                    buttonText: 'decline',
                  ),
                ),
                20.widthBox,
                Expanded(
                  child: TaxiButton(
                    onPressed:() => onAcceptTrip(context),
                    buttonText: 'Accept',
                  ),
                ),
              ],
            ),
            35.heightBox,
          ],
        ).pSymmetric(h: 16),
      ),
    );
  }

  void onAcceptTrip (BuildContext context) async {
    if (await isTripAvailable(context, tripModel.id)) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ProgressDialog(status: 'Loading..'),
      );

      try {
        final String url = serviceUrls.acceptNewTrip;

        Map<String, dynamic> response = await RequestHelper.putRequest(
          url: url,
          body: tripModel.toJson(),
          token: Provider.of<AppData>(context, listen: false).getAuthToken(),
        );

        FirebaseDatabase.instance.reference().child('rideRequest').child(tripModel.id).remove();

        if (response['message'] == 'success') {
          logger.i('trip accepted by driver');
          Navigator.of(context).pop(); //loading dialog
          
          showModalBottomSheet(
            context: context, 
            isDismissible: false,
            builder: (context) => Container(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close),
                    ),
                    "Trip Accepted by ${tripModel.driver.fullName}".text.xl.makeCentered(),
                    "Rider name : ${tripModel.rider.fullName}".text.xl.makeCentered(),
                    "Phone : ${tripModel.rider.phone}".text.xl.makeCentered(),
                  ],
                ),
              ),
            ),
          );
        } else {
          throw Exception('Exception occurred while accepting trip');
        }
      } catch (e) {
        logger.e(e);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('trip not available')));
      logger.e('Trip not available');
    }
  }

  Future<bool> isTripAvailable(BuildContext context, String tripId) async {
    try {
      DatabaseReference tripRef = FirebaseDatabase.instance.reference().child('rideRequest');
      DataSnapshot snapshot = await tripRef.child(tripId).once();
      if(snapshot.value != null){
        return true;
      }
      return false;
    } catch(e) {
        logger.e(e);
        throw e;
    }
  }
}
