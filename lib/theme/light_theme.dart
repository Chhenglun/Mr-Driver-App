// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  textTheme: TextTheme(
    displayLarge: TextStyle(color: Colors.black),
    displayMedium: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black),
  ),
  fontFamily: 'Mulish',
  primaryColor: Color(0xFFE1BB17),
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: Colors.grey.shade400,
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);