// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/style.dart';

class CustomListWidget {
  //Todo: customListTileSettingScreen
  static Widget customListTileSettingScreen({
    required String title,
    required IconData icon,
    required trailing,
    bool isSwitched = false,
    required Function onPress,
    Function(bool)? onChange,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: ColorResources.blackColor,
        size: 22,
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text(
          title,
          style: textStyleMedium.copyWith(
            fontSize: 18,
            color: ColorResources.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      titleAlignment: ListTileTitleAlignment.center,
      trailing: trailing,
      onTap: () => onPress(),
    );
  }

  //Todo: customListTileNew
  static Widget customListTile({
    required String title,
    required Function onPress,
    required IconData iconleading, 
  }) {
    return Container(
      width: Get.width * 0.9,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            ColorResources.backgroundBannerColor,
            ColorResources.primaryColor.withOpacity(0.4)
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(iconleading, color: ColorResources.primaryColor,) ,
        title: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            title,
            style: textStyleMedium.copyWith(
              fontSize: 18,
              color: ColorResources.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        titleAlignment: ListTileTitleAlignment.center,
        trailing: IconButton(
          icon: Icon(Icons.edit , color: ColorResources.primaryColor, size: 30,),
          color: ColorResources.primaryColor,
          onPressed: () => onPress(),
        ),
        onTap: () => onPress(),
      ),
    );
  }

  //Todo: Texformfield
  static Widget customTextformfield({
    required String labelText,
    required IconData icon,
    required Function(String) validator,
    required Function(String) onChanged,
    required TextInputType keyboardType,
    required bool obscureText,
    required TextInputAction textInputAction,
    required TextStyle style,
    required TextEditingController controller,
  }) {
    {
      return TextFormField(
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        style: style,
        validator: (value) => validator(value!),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          prefixIconColor: Colors.grey,
          labelText: labelText,
          floatingLabelStyle: TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 2)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white, width: 2)),
          labelStyle: TextStyle(color: Colors.grey),
        ),
      );
    }
  }
}
