// ignore_for_file: prefer_collection_literals, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:capstone_project2/data/api/api_client.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../controller/booking_process_controller.dart';
import '../controller/localization_controller.dart';
import '../controller/splash_controller.dart';
import '../controller/theme_controller.dart';
import '../data/model/response/language_model.dart';
import '../data/repository/auth_repository.dart';
import '../data/repository/booking_process_repository.dart';
import '../data/repository/language_repository.dart';
import '../util/app_constants.dart';
import 'network_info.dart';

Future<Map<String, Map<String, String>>> init() async {

  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => NetworkInfo(Get.find()));
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => DioClient(appBaseUrl: AppConstants.baseURL, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => LanguageRepository());
  Get.lazyPut(() => AuthRepository(dioClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => GetBookingRequestRepository(dioClient: Get.find(), sharedPreferences: sharedPreferences));


  // Controller
  Get.lazyPut(() => SplashController());
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find(), dioClient: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthController(authRepository: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => BookingProcessController(getBookingRequestController: Get.find(), sharedPreferences: Get.find()));


  // Retrieving localized data
  Map<String, Map<String, String>> languages = Map();
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle.loadString('assets/languages/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();
    mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = _json;
  }
  return languages;
}
