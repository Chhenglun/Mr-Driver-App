import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/dimensions.dart';
import 'package:scholarar/util/style.dart';

void customShowTopBanner(BuildContext context, String message, {bool isError = true, Color? colors}) {
  final materialBanner = MaterialBanner(
    backgroundColor: Colors.transparent,
    content: Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: colors ?? (isError ? ColorResources.errorColor : ColorResources.successColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white),
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        },
        child: Text(
          'DISMISS',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showMaterialBanner(materialBanner);

  Future.delayed(Duration(seconds: 5), () {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  });
}
