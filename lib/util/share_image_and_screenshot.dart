// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:get/get.dart';
import 'package:scholarar/util/image_gallery_saver.dart';
import 'package:scholarar/view/custom/custom_show_snakbar.dart';
import 'package:share_plus/share_plus.dart';

class ShareImageAndScreenShot{

  screenShot(GlobalKey globalKey, context, {bool isScreenShot = true}) async {
    RenderRepaintBoundary boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      customShowSnackBar(isScreenShot ? 'screenshotSuccess'.tr : "downloadSuccess".tr, context, isError: false);
    }
  }

  Future<void> shareImage(GlobalKey globalKey, context, {bool? isGoBack = true}) async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = File('${(await getTemporaryDirectory()).path}/sunpay.png');
      imgFile.writeAsBytesSync(pngBytes);
      final RenderBox box = context.findRenderObject() as RenderBox;
      Share.shareXFiles(
        [XFile(imgFile.path)],
        text: 'helloPleaseCheckMyTransfer'.tr,
        subject: 'sunpayTransfer'.tr,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      ).then((_){
        if(isGoBack == true){
          Get.back();
        }
      });
    } catch (e) {
      print(e);
    }
  }
}