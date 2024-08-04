import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import '../booking/open_booking.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  bool isLoading = false;
  AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  void checkUserStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      await authController.getDriverProfileController();
      String userApprove = authController.userDriverMap?["userDetails"]["status_register"] ?? '';
      if (userApprove == "approved") {
        nextScreenReplace(context, OpenBooking());
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.secondaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorResources.primaryColor,
        title: Text("សូមមេត្តារង់ចាំការយល់ព្រមពីក្រុមការងារ", style: TextStyle(color: Colors.white,fontSize: 16)),
        actions: [
          IconButton(
            onPressed: () {
              checkUserStatus();
            },
            icon: FaIcon(FontAwesomeIcons.refresh),
            color: Colors.white,
          )
        ],
      ),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: ColorResources.primaryColor,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              SizedBox(height: 32),
              Text(
                "សូមអរគុណសម្រាប់ការចុះឈ្មោះ",
                style: TextStyle(fontSize: 20, color: ColorResources.primaryColor, ),
              ),
              SizedBox(height: 8,),
              Text(
                "ពួកយេីងនឹងផ្ទៀងផ្ទាត់គណនីរបស់អ្នក",
                style: TextStyle(fontSize: 20, color: ColorResources.primaryColor,),
              ),
              SizedBox(height: 16),
              Text("សូមមេត្តារង់ចាំ...",style: TextStyle(fontSize: 16,color: ColorResources.blackColor),),
              SizedBox(height: 16),
              if (isLoading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryColor,),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
