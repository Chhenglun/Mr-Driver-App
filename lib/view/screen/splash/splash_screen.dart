import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/controller/splash_controller.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/screen/account/singin_account_screen.dart';
import 'package:scholarar/view/screen/account/waiting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../booking/open_booking.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? sharedPreferences;
  AuthController authController = Get.find<AuthController>();
  SplashController splashController = Get.find<SplashController>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    afterSplash();
  }

  Future<void> afterSplash() async {
    sharedPreferences = await SharedPreferences.getInstance();
    splashController.changeIndex(0);

    if (mounted) {
      if (sharedPreferences!.containsKey(AppConstants.token)) {
        String? token = sharedPreferences!.getString(AppConstants.token);
        if (token != null && token.isNotEmpty) {
          print("Token: $token");
          try {
            // Fetch user profile data
            await authController.getDriverProfileController();

            // Check user approval status after fetching profile data
            String userApprove = authController.userDriverMap?["userDetails"]["status_register"] ?? 'N/A';
            print("User Approve: $userApprove");

            if (userApprove == "approved") {
              print("User Approved: $userApprove");
              nextScreenReplace(context, OpenBooking());
            } else {
              print("User not approved, going to Waiting Screen");
              nextScreenReplace(context, WaitingScreen());
            }
          } catch (e) {
            print('Error: $e');
            Timer(Duration(seconds: 5), () {
              nextScreenReplace(context, SignInAccountScreen());
            });
          }
        } else {
          Timer(Duration(seconds: 5), () {
            nextScreenReplace(context, SignInAccountScreen());
          });
        }
      } else {
        Timer(Duration(seconds: 5), () {
          nextScreenReplace(context, SignInAccountScreen());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: Center(
        child: Image(
          width: 300,
          height: 300,
          image: AssetImage(AppConstants.logo),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}



/*


// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/controller/splash_controller.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/screen/account/signup_account_screen.dart';
import 'package:scholarar/view/screen/account/singin_account_screen.dart';
import 'package:scholarar/view/screen/account/waiting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../booking/open_booking.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? sharedPreferences;
  AuthController authController = Get.find<AuthController>();
  SplashController splashController = Get.find<SplashController>();
  bool isLoading = false;
  Future<void> init() async {
    await authController.getDriverProfileController();
    setState(() {
      isLoading = false;
    });
  }

  */
/*@override
  void initState() {
    setState(() {
      init();
    });
    super.initState();
  }*//*

  @override
  void initState() {
    init();
    super.initState();
    afterSplash();
  }
  afterSplash() async {
    sharedPreferences = await SharedPreferences.getInstance();
    splashController.changeIndex(0);
    if (mounted) {
      if(sharedPreferences!.containsKey(AppConstants.token)) {
        print("Token: ${sharedPreferences!.getString(AppConstants.token)}");
        try {
          String token = sharedPreferences!.getString(AppConstants.token)!;
          print("Token: $token");
          String userApprove = authController.userDriverMap?["userDetails"]["status_register"];
          print("User Approve: $userApprove");
          if (token.isNotEmpty  && userApprove == "approved") {
            print("First Check Token $token");
            nextScreenReplace(context, OpenBooking());
            */
/*await authController.getDriverProfileController().then((_) {
            nextScreenReplace(Get.context, OpenBooking());
          });*//*

          } else {
            print("Logout Token: ");
            nextScreenReplace(context, WaitingScreen());
          }
        } catch (e) {
          print('else');
          Timer(Duration(seconds: 5), () {
            nextScreenReplace(Get.context, SignInAccountScreen());
          });
        }
      }
      }
      */
/*try {
        String token = sharedPreferences!.getString(AppConstants.token)!;
        print("Token: $token");
        String userApprove = authController.userDriverMap?["userDetails"]["status_register"];
        print("User Approve: $userApprove");
        if (token.isNotEmpty  && userApprove == "approved") {
          print("First Check Token $token");
          nextScreenReplace(context, OpenBooking());
          *//*
*/
/*await authController.getDriverProfileController().then((_) {
            nextScreenReplace(Get.context, OpenBooking());
          });*//*
*/
/*
        } else {
          print("Logout Token: ");
          nextScreenReplace(context, WaitingScreen());
        }
      } catch (e) {
        print('else');
        Timer(Duration(seconds: 5), () {
          nextScreenReplace(Get.context, SignInAccountScreen());
        });
      }
    }*//*

  }

  */
/*@override
  void initState() {
    setState(() {
      init();
    });
    super.initState();
    afterSplash();
  }*//*


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: Center(
        child: Image(
          width: 300,
          height: 300,
          image: AssetImage(AppConstants.logo),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
*/
