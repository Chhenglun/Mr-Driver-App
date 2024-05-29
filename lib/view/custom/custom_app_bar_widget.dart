// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/util/style.dart';
import 'package:scholarar/view/screen/notification/notification_screen.dart';
import 'package:scholarar/view/screen/search/search_screen.dart';

import '../screen/account/login_screen.dart';

class CustomAppbarWidget {
  // Todo: buildButtonClick
  static AppBar buildAppBar(
      BuildContext context, {String? userName, String? img,
        Function()? tapLogin, Function()? tapSearch, Function()? tapNotification
      }) {
    return AppBar(
      backgroundColor: ColorResources.primaryColor,
      elevation: 0,
      centerTitle: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      title: Row(
        children: [
          IconButton(
            onPressed: tapLogin,
            icon: FaIcon(
              FontAwesomeIcons.circleUser,
              color: Colors.white,
            ),
          ),
          Text(userName ?? "", style: textStyleMedium.copyWith(color: Colors.white)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: tapSearch,
          icon: Icon(Icons.search, color: Colors.white, size: 28),
        ),
        IconButton(
          onPressed: tapNotification,
          icon: Icon(Icons.notifications, color: Colors.white, size: 32),
        )
      ],
    );
  }
}
