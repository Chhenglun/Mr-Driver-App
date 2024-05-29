// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Mulish',
  primaryColor: Color(0xFF27AE60),
  brightness: Brightness.dark,
  highlightColor: Colors.black,
  hintColor: Colors.grey.shade100,
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);