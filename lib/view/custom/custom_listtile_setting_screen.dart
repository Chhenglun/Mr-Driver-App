// ignore_for_file: prefer_const_constructors
import 'package:capstone_project2/util/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomListWidget {
  //Todo: customListTileSettingScreen
  static Widget customListTileSettingScreen({
    required String title,
    Widget? titleColors,
    required IconData icon,
    //required trailing,
    bool isSwitched = false,
    required Function onPress,
    Function(bool)? onChange,
    //required Function onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.blueGrey,
        //size: 22,
      ),
      title: Text(
        title,
        style: textStyleMedium.copyWith(
          fontSize: 18,
          color: titleColors!=null ? Colors.blueGrey : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      titleAlignment: ListTileTitleAlignment.center,
      trailing: FaIcon(FontAwesomeIcons.angleRight, color: Colors.blueGrey),
      // trailing: IconButton(
      //   icon: FaIcon(FontAwesomeIcons.angleRight, color: Colors.blueGrey),
      //   onPressed: () => onTap(),
      // ),
      onTap: () => onPress(),
    );
  }

  //Todo: customListTileNew
  static Widget customListTile({
    required String title,
    required Function onPress,
    required IconData iconleading, 
  }) {
    return ListTile(
      leading: Icon(iconleading, color: Colors.blueGrey,) ,
      title: Text(
        title,
        style: textStyleMedium.copyWith(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      titleAlignment: ListTileTitleAlignment.center,
      // trailing: IconButton(
      //   icon: Icon(Icons.edit , color: Colors.blueGrey, size: 20,),
      //   color: ColorResources.primaryColor,
      //   onPressed: () => onPress(),
      // ),
      onTap: () => onPress(),
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
