// ignore_for_file: prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/dimensions.dart';
import 'package:scholarar/util/style.dart';

void customShowSnackBar(String message, BuildContext context, {bool isError = true, Color? colors}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
      ),
      backgroundColor: colors == null ? isError ? ColorResources.errorColor : ColorResources.successColor : colors,
    ),
  );
}