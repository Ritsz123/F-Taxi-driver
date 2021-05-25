import 'package:flutter/material.dart';
import 'package:uber_driver_app/Colors.dart';
import 'package:velocity_x/velocity_x.dart';

class TaxiButton extends StatelessWidget {
  final String buttonText;
  final Function? onPressed;
  final Color? color;
  final double? textSize;

  TaxiButton(
      {required this.onPressed,
      required this.buttonText,
      this.color,
      this.textSize});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed as void Function()?,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color: color == null ? MyColors.colorGreen : color,
      textColor: Colors.white,
      child: buttonText.text
          .size(textSize == null ? 18 : textSize)
          .uppercase
          .fontFamily('Brand-Bold')
          .makeCentered()
          .box
          .height(50)
          .make(),
    );
  }
}
