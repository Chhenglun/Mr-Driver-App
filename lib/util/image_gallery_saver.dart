import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class ImageGallerySaver {
  static const MethodChannel _channel = MethodChannel('image_gallery_saver');
  static FutureOr<dynamic> saveImage(
    Uint8List imageBytes,
    {int quality = 50, String? name, bool isReturnImagePathOfIOS = false
  }) async {
    if(Platform.isIOS) {
      quality = 100;
    }
    final result = await _channel.invokeMethod(
      'saveImageToGallery', <String, dynamic>{
        'imageBytes': imageBytes,
        'quality': quality,
        'name': name,
        'isReturnImagePathOfIOS': isReturnImagePathOfIOS
      }
    );
    return result;
  }
}