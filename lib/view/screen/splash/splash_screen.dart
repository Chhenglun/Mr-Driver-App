import 'dart:async';
import 'package:capstone_project2/view/screen/account/waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/auth_controller.dart';
import '../../../controller/booking_process_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../util/app_constants.dart';
import '../../../util/color_resources.dart';
import '../../../util/next_screen.dart';
import '../account/singin_account_screen.dart';
import '../booking/driver_go_to_passenger_screen.dart';
import '../booking/open_booking.dart';
import '../booking/opening_booking.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? sharedPreferences;
  AuthController authController = Get.find<AuthController>();
  BookingProcessController bookingController = Get.find<BookingProcessController>();
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
                  await bookingController.getTripInfo(bookingController.tripID);
                  final status = bookingController.tripInfo?["status"];
                  if (status == "requested"){
                    nextScreenNoReturn(Get.context, DriverPickPassenger());
                  }
                  print("User not approved, navigating to WaitingScreen");
                  nextScreenReplace(context, OpeningBooking());
                }
              } else {
                // I want to take status to use here
              nextScreen(context, WaitingScreen());
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
