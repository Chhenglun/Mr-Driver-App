// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarar/util/color_resources.dart';

// Todo : CustomNotificationDialog
Future customNotificationDialog({required BuildContext context,required String title,required String body, void Function()? onTap}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: ColorResources.transparentColor,
        child: Container(
          width: Get.width,
          padding: EdgeInsets.only( top: 20, bottom: 10, ),
          decoration: BoxDecoration(color: ColorResources.primaryColor.withOpacity(0.9) , borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500 ,
                    color: ColorResources.whiteColor,
                 ),
                ),
              ),
              SizedBox(
                height: 20,
                child: Divider(
                  color: ColorResources.whiteColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: ColorResources.whiteColor,
                      child: Icon(Icons.person, color: Colors.black, size: 45),
                    ),
                    SizedBox(width: 20),
                    //check condition that if word text have more than 3 word please allow \n
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.justify,
                        body,
                        style: TextStyle(
                            fontSize: 18,
                            color: ColorResources.whiteColor,
                            wordSpacing: 1.5),),
                    ),
                    /*Column(
                      children: [
                        Text(username, style: TextStyle(fontSize: 18, color: ColorResources.whiteColor,),),
                        SizedBox(height: 5),
                        Text(phoneNumber, style: TextStyle(fontSize: 16, color: ColorResources.whiteColor,),),
                      ],
                    )*/


                  ],
                ),
              ),
             /* Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),*/
              SizedBox(height: 20),
              Container(
                width: Get.width,
                height: 1,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onTap,
                        child: Text("Decline", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorResources.redColor)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onTap,
                        child: Text("Accept", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorResources.blueColor)),
                    ),),
                  ],
                ),
              ),
              /*GestureDetector(
                onTap: onTap,
                child: Container(
                  alignment: Alignment.center,
                  width: Get.width,
                  color: Colors.transparent,
                  child: Text(btnText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorResources.blueColor)),
                ),
              ),*/
            ],
          ),
        ),
      );
    },
  );
}