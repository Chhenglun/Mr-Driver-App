import 'package:flutter/material.dart';

import '../../util/color_resources.dart';
import '../../util/dimensions.dart';
import '../../util/style.dart';

void customShowTopDropDown(String message, BuildContext context, {bool isError = false, Color? colors}) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors ?? (isError ? ColorResources.successColor : ColorResources.errorColor),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black, width: 1), // Dark border
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Text(
            message,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black), // Dark text color
          ),
        ),
      ),
    ),
  );

  OverlayState? overlayState = Overlay.of(context);

  if (overlayState != null) {
    overlayState.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
