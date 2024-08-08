// ignore_for_file: prefer_const_constructors

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../util/color_resources.dart';
import '../../../util/next_screen.dart';
import '../../../util/style.dart';
import 'current_location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TypewriterAnimatedTextKit(
          text: ['Mr Passenger CAM'],
          textStyle: textStyleMedium.copyWith(
            fontSize: 20,
            color: ColorResources.primaryColor,
          ),
          // textStyle: TextStyle(
          //   color: ColorResources.primaryColor,
          //   fontSize: 20.0,
          //   fontWeight: FontWeight.bold,
          // ),
          speed: Duration(milliseconds: 200),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                color: Colors.red,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.red),
          ),
          onPressed: () {
            nextScreen(context, CurrentLocation());
          },
          child: Text(
            'Booking',
            style: TextStyle(color: Colors.white),
          ),
        )),
      ),
    );
  }
}
