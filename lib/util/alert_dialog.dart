// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarar/util/color_resources.dart';

// Todo : CustomNotificationDialog
Future customNotificationDialog({required BuildContext context,required String title,required String content,required String btnText, void Function()? onTap}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: Get.width,
          padding: EdgeInsets.only( top: 20, bottom: 10, ),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
              SizedBox(height: 20),
              Container(
                width: Get.width,
                height: 1,
                color: Colors.grey[300],
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  alignment: Alignment.center,
                  width: Get.width,
                  color: Colors.transparent,
                  child: Text(btnText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorResources.blueColor)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}