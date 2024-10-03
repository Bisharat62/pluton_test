import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pluton_test/other_services/utils/alert_boxes.dart';
import 'package:pluton_test/other_services/utils/snackbar.dart';
import 'package:pluton_test/view/screens/auth_screens/login_screen.dart';
import 'package:pluton_test/view/screens/post_screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  bool _isLoggedIn = false;
  RxBool isLoading = true.obs;
  RxBool isLoggedInLoading = true.obs;
  bool get isLoggedIn => _isLoggedIn;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkLoggedIn();
  }

  checkLoggedIn() async {
    isLoggedInLoading.value = true;
    log("$isLoggedInLoading");
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLoggedInval = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedInval) {
      Get.offAll(() => const HomeScreen());
    }
    //delayed is perfom to not load build function of login screen just wait for fewer time to update value
    // if delayed is not performed the screen builds show login buttons for few seconds then navigate to home screen
    Future.delayed(const Duration(milliseconds: 300), () {
      isLoggedInLoading.value = false;
    });
  }

// this function is performed to update value of local shared prefs
  checkLogedIn({bool? vales}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (vales != null) {
      await prefs.setBool('isLoggedIn', vales);
    } else {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    }
  }

// login with google function is called
  Future<dynamic> signInWithGoogle() async {
    showLoader();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var data = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .whenComplete(() {
        log("logged in");
        checkLogedIn(vales: true);
        hideLoader();
        showInSnackBar("Login Succefull");
        Get.offAll(() => const HomeScreen());
      });
    } on Exception catch (e) {
      hideLoader();

      showInSnackBar("Something Went Wrong Try Again", color: Colors.red);

      print('exception->$e');
    }
  }

// sign out from google login
  Future<bool> signOutFromGoogle() async {
    showLoader();
    try {
      await FirebaseAuth.instance.signOut();

      checkLogedIn(vales: false);

      hideLoader();
      Get.offAll(() => const LoginScreen());

      showInSnackBar("Logout Succefull");
      return true;
    } on Exception catch (_) {
      hideLoader();
      showInSnackBar("Something Went Wrong Try Again", color: Colors.red);
      return false;
    }
  }
}
