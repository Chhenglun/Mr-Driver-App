import 'package:get/get.dart';

import '../helper/responsive_helper.dart';

class Dimensions {
  static double fontSizeextraExtraSmall = Responsive.isTab() ? 10 : (Get.width >= 1300 ? 12 : 8);
  static double fontSizeExtraSmall = Responsive.isTab() ? 11 : (Get.width >= 1300 ? 14 : 10);
  static double fontSizeSmall = Responsive.isTab() ? 13: (Get.width >= 1300 ? 16 : 12);
  static double fontSizeDefault = 16;
  static double fontSizeLarge = Responsive.isTab() ? 20 : (Get.width >= 1300 ? 20 : 16);
  static double fontSizeExtraLarge = Responsive.isTab() ? 28 : (Get.width >= 1300 ? 22 : 18);
  static double fontSizeOverLarge = Responsive.isTab() ? 34 : (Get.width >= 1300 ? 28 : 24);
  static const double paddingSizeExtraExtraSmall = 2.0;
  static const double paddingSizeExtraSmall = 6.0;
  static const double paddingSizeSmall = 10.0;
  static const double paddingSizeDefault = 15.0;
  static const double homePagePadding = 16.0;
  static const double paddingSizeDefaultAddress = 17.0;
  static const double paddingSizeLarge = 20.0;
  static const double paddingSizeExtraLarge = 25.0;
  static const double paddingSizeThirty = 30.0;
  static const double paddingSizeOverLarge = 50.0;
  static const double marginSizeExtraSmall = 5.0;
  static const double marginSizeSmall = 10.0;
  static const double marginSizeDefault = 15.0;
  static const double marginSizeLarge = 20.0;
  static const double marginSizeExtraLarge = 25.0;
  static const double marginSizeAuthSmall = 30.0;
  static const double marginSizeAuth = 50.0;
  static const double borderRadius = 4.0;
  static double iconSizeSmall = 24;
  static double iconSizeExtraSmall = 20;
  static double iconDefaultSize = 28;
  static double iconSizeMedium = Responsive.isTab() ? 28 : (Get.width >= 1300 ? 22 : 20);
  static double iconSizeDefault = Responsive.isTab() ? 34 : (Get.width >= 1300 ? 28 : 24);
  static double iconSizeMediumLarge = Responsive.isTab() ? 48 : (Get.width >= 1300 ? 42 : 38);
  static const double imageSizeExtraSeventy = 70.0;
  static const double topSpace = 30.0;
  static const double splashLogoWidth = 150.0;
  static const double chooseReviewImageSize = 40.0;
  static const double profileImageSize = 100.0;
  static const double logoHeight = 80.0;
}
