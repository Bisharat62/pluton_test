import 'package:flutter/material.dart';
import 'package:get/get.dart';

//common widget for adding space between two widgets
//widget values should be between 0-1
Widget vertical(double height) {
  return SizedBox(
    height: Get.height * height,
  );
}

Widget horizontal(double width) {
  return SizedBox(
    width: Get.width * width,
  );
}
