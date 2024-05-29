// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/controller/splash_controller.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/app/app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? sharedPreferences;
  AuthController authController = Get.find<AuthController>();
  SplashController splashController = Get.find<SplashController>();

  afterSplash() async {
    sharedPreferences = await SharedPreferences.getInstance();
    splashController.changeIndex(0);
    if (mounted) {
      try {
        String token = sharedPreferences!.getString(AppConstants.token)!;
        if (token.isNotEmpty) {
          print("First Check Token $token");
          await authController.getUserInfo().then((_) {
            nextScreenReplace(Get.context, AppScreen());
          });
        } else {
          print("Logout Token: ");
          nextScreenReplace(context, AppScreen());
        }
      } catch (e) {
        print('else');
        Timer(Duration(seconds: 5), () {
          nextScreenReplace(Get.context, AppScreen());
        });
        
      }
    }
  }

  @override
  void initState() {
    super.initState();
    afterSplash();
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
        )));
  }
}
