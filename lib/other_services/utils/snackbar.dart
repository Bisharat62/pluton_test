import 'package:flutter/material.dart';
import 'package:get/get.dart';

GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

void showInSnackBar(String value,
    {Color? color, int? duration, IconData? icon}) {
  FocusManager.instance.primaryFocus?.unfocus();
  final SnackBar snackBar = SnackBar(
    margin: EdgeInsets.only(bottom: Get.height * 0.01, left: 30, right: 30),
    content: Row(
      children: [
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: 'caviarbold'),
          ),
        ),
      ],
    ),
    dismissDirection: DismissDirection.up,
    backgroundColor: color ?? Colors.green,
    behavior: SnackBarBehavior.floating,
    duration: Duration(milliseconds: duration ?? 1500),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );

  snackbarKey.currentState?.showSnackBar(snackBar);
}
