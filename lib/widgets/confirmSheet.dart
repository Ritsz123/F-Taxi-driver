import 'package:flutter/material.dart';
import 'package:uber_driver_app/Colors.dart';
import 'package:uber_driver_app/widgets/taxiButton.dart';
import 'package:uber_driver_app/widgets/taxiOutlineButton.dart';
import 'package:velocity_x/velocity_x.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function onPressed;
  final bool isOnline;

  ConfirmSheet(
      {this.isOnline, @required this.title, this.onPressed, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      child: Column(
        children: [
          10.heightBox,
          title.text.uppercase
              .size(22)
              .fontFamily("Brand-Bold")
              .color(MyColors.colorText)
              .makeCentered(),
          20.heightBox,
          subTitle.text.size(16).color(MyColors.colorTextLight).makeCentered(),
          20.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: TaxiOutlineButton(
                    title: "CANCEL",
                    color: MyColors.colorLightGrayFair,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              20.widthBox,
              Expanded(
                child: Container(
                  child: TaxiButton(
                    color: isOnline ? MyColors.colorRed : MyColors.colorGreen,
                    onPressed: onPressed,
                    buttonText: "CONFIRM",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
