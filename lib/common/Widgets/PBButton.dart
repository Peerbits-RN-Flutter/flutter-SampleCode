import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PBButton extends StatelessWidget {
  Function() onPress;
  Widget child;
  var color;
  bool? isForSend;
  double? elevation;

  PBButton(
      {required this.onPress,
      required this.child,
      this.color,
      this.isForSend,
      this.elevation});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 56.0,
      minWidth: this.isForSend != null && this.isForSend == true
          ? null
          : Get.width - 32,
      onPressed: onPress,
      elevation: elevation ?? 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: this.isForSend != null && this.isForSend == true
            ? BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0))
            : BorderRadius.circular(8.0),
      ),
      textColor: Colors.white,
      child: child,
      color: color ?? Theme.of(context).accentColor,
    );
  }
}
