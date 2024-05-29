// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:scholarar/util/color_resources.dart';

class CustomButtonWidget {
  // Todo: buildButtonClick
  static Widget buildButtonClick(
      {required String title,
        required double size,
        bool activeColor = false,
        bool textBold = true,
        void Function()? onPress}) {
    return SizedBox(
      width: double.infinity,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            width: activeColor ? 0 : 1,
            color: activeColor ? Colors.transparent : Colors.grey,
          ),
          backgroundColor: activeColor ? ColorResources.primaryColor : ColorResources.greyColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        onPressed: onPress,
        child: Text(
          title,
          // style: GoogleFonts.montserrat(
          //   color: activeColor ? ColorResources.whiteColor : ColorResources.whiteColor,
          //   fontSize: 16,
          //   fontWeight: textBold ? FontWeight.w500 : FontWeight.normal,
          // ),
        ),
      ),
    );
  }

  //Todo : buildBoxButtonPay
  static Widget buildBoxButtonPay(
      {required String title,
        required dynamic price,
        bool isSelected = true,
        void Function()? onPress}) {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: onPress,
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorResources.whiteBackgroundColor
                    : Colors.blue,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 14,
                          color: isSelected
                              ? ColorResources.primaryColor
                              : Colors.black),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    "\$$price",
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 3,
              right: 3,
              child: CircleAvatar(
                radius: 10,
                backgroundColor:
                isSelected ? ColorResources.primaryColor : Colors.greenAccent,
                child: isSelected
                    ? null
                    : Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}