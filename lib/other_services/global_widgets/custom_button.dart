import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback ontap;
  final double width;
  final double? height;
  final double? fontsize;
  final String text;
  final Color? bgColor;
  final Color? fontColor;
  final Widget? child;
  const CustomButton(
      {super.key,
      required this.ontap,
      required this.width,
      required this.text,
      this.height,
      this.fontsize,
      this.bgColor,
      this.fontColor,
      this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: height ?? 45,
        width: Get.width * width,
        decoration: BoxDecoration(
            color: bgColor ?? AppColors.blue,
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: child ??
              Text(
                text,
                style: TextStyle(
                    fontSize: fontsize ?? 18, color: fontColor ?? Colors.white),
              ),
        ),
      ),
    );
  }
}
