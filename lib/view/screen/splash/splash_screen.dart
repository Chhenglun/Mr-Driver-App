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
import 'package:scholarar/view/screen/booking/opening_booking.dart';
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
        final token = sharedPreferences!.getString(AppConstants.token);
        if (token != null && token.isNotEmpty) {
          print("Token found: $token");
          try {
            await authController.getDriverProfileController();
            final userDetails = authController.userDriverMap?["userDetails"];
            if (userDetails != null) {
              final statusRegister = userDetails["status_register"];
              final deviceToken = userDetails["deviceToken"];
              print("User Details: $userDetails");

              if (statusRegister == "approved") {
                if (deviceToken == null || deviceToken.isEmpty) {
                  print("User has no device token, navigating to OpenBooking");
                  nextScreenReplace(context, OpenBooking());
                } else {
                  print("User has device token, navigating to OpeningBooking");
                  nextScreenReplace(context, OpeningBooking());
                }
              } else {
                print("User not approved, navigating to WaitingScreen");
                nextScreenReplace(context, WaitingScreen());
              }
            } else {
              print("User details are null");
              nextScreenReplace(context, SignInAccountScreen());
            }
          } catch (e) {
            print('Error fetching user profile: $e');
            nextScreenReplace(context, SignInAccountScreen());
          }
        } else {
          print("Token is null or empty, navigating to SignInAccountScreen");
          nextScreenReplace(context, SignInAccountScreen());
        }
      } else {
        print("No token found, navigating to SignInAccountScreen");
        nextScreenReplace(context, SignInAccountScreen());
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
