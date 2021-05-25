import 'package:flutter/material.dart';
import 'package:uber_driver_app/Colors.dart';

class TaxiOutlineButton extends StatelessWidget {
  final String? title;
  final Function? onPressed;
  final Color? color;

  TaxiOutlineButton({this.title, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(color: color!),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      onPressed: onPressed as void Function()?,
      color: color,
      textColor: color,
      child: Container(
        height: 50.0,
        child: Center(
          child: Text(
            title!,
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Brand-Bold',
              color: MyColors.colorText,
            ),
          ),
        ),
      ),
    );
  }
}
