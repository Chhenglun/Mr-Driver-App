// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  bool isLoading = false;
  /* AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  init(){
    setState(() {
      isLoading = true;
      _authController.refreshScreen();
    });


  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.secondaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorResources.primaryColor,
        /* leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Get.back();
        },
      ),*/
        title: Text("Waiting for verification", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              isLoading = true;
            },);

          }, icon: FaIcon(FontAwesomeIcons.refresh), color: Colors.white)
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
                "Thanks for your register!  We will verify your account soon.",
                style: TextStyle(fontSize: 20, color: ColorResources.primaryColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text("Please wait..."),
              SizedBox(height: 16),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
