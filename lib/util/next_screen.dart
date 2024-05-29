import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void  nextScreen(context, page) {
  Get.to(page, transition: Transition.rightToLeft);
}

void nextScreenIOS(context, page) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> page));
}

void nextScreenNoReturn(context, page) {
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => page), (route) => false);
}

// Future<bool> onBackPress(BuildContext context, ScholarshipScreen scholarshipScreen) async {
//   Navigator.popUntil(context, (route) => route.isFirst);
//   return true;
// }