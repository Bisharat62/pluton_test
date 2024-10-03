import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluton_test/controller/auth_controller.dart';
import 'package:pluton_test/other_services/global_widgets/custom_button.dart';
import 'package:pluton_test/other_services/global_widgets/spacer_widget.dart';
import 'package:pluton_test/other_services/utils/app_assets.dart';
import 'package:pluton_test/other_services/utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Obx(() {
            log("---------${authController.isLoggedInLoading.value}");
            return authController.isLoggedInLoading.value == true
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      vertical(0.135),
                      Image.asset(
                        AppAssets.testlogo,
                        width: Get.width * 0.35,
                      ),
                      vertical(0.135),
                      CustomButton(
                        bgColor: AppColors.red,
                        ontap: () {
                          authController.signInWithGoogle();
                        },
                        width: 1,
                        text: "",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.googlelogo,
                              color: Colors.white,
                              height: 25,
                            ),
                            horizontal(0.02),
                            const Text(
                              "Signin With Google",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      vertical(0.02),
                      CustomButton(
                        ontap: () {},
                        width: 1,
                        text: "",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.applelogo,
                              color: Colors.white,
                              height: 25,
                            ),
                            horizontal(0.02),
                            const Text(
                              "Signin With Apple",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "By Sign-in, you are agree to our ",
                          style: const TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Terms & Conditions',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => print('Tap Here onTap'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blue,
                                    decoration: TextDecoration.underline)),
                            const TextSpan(
                                text: ' & ',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                            TextSpan(
                                text: 'Privacy Policy',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => print('Tap Here onTap'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: 2,
                                    color: AppColors.blue,
                                    decoration: TextDecoration.underline)),
                          ],
                        ),
                      ),
                      vertical(0.02)
                    ],
                  );
          }),
        ).paddingSymmetric(horizontal: Get.width * 0.05),
      ),
    );
  }
}
