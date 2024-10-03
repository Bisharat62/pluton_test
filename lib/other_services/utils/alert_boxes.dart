import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluton_test/controller/post_controller.dart';
import 'package:pluton_test/other_services/utils/app_colors.dart';

showLoader() {
  Get.dialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      const CircleAvatar(
        radius: 10,
        backgroundColor: AppColors.blue,
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )),
      ).paddingSymmetric(horizontal: Get.width * 0.43));
}

hideLoader() {
  Get.back();
}

void showDeleteConfirmationDialog(int index) {
  final PostController postController = Get.find<PostController>();
  Get.defaultDialog(
    title: "Confirm Deletion",
    titleStyle: const TextStyle(color: Colors.red),
    middleText: "Are you sure you want to delete this post?",
    textConfirm: "Yes",
    textCancel: "No",
    onConfirm: () {
      Get.back();
      postController.deletePost(postController.postsData[index].id!, index);
      // Perform post deletion logic here
      // print("Post deleted: $postId");
      // Close the dialog
    },
    onCancel: () {
      Get.back(); // Close the dialog without deleting
    },
  );
}

Future<bool> showConfirmationDialog(String title, String message) async {
  bool val = await Get.defaultDialog(
    title: title,
    titleStyle: const TextStyle(color: Colors.red),
    middleText: message,
    textConfirm: "Yes",
    textCancel: "No",
    onCancel: () => Get.back(result: false),
    onConfirm: () => Get.back(result: true),
    // onConfirm: () {
    //   value = true;
    // },
  );
  return val ?? false;
}
