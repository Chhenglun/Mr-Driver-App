// ignore_for_file: prefer_collection_literals, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/controller/book_store_controller.dart';
import 'package:scholarar/controller/course_controller.dart';
import 'package:scholarar/controller/home_controller.dart';
import 'package:scholarar/controller/localization_controller.dart';
import 'package:scholarar/controller/splash_controller.dart';
import 'package:scholarar/controller/test_controller.dart';
import 'package:scholarar/controller/theme_controller.dart';
import 'package:scholarar/data/api/api_client.dart';
import 'package:scholarar/data/model/response/language_model.dart';
import 'package:scholarar/data/repository/auth_repository.dart';
import 'package:scholarar/data/repository/book_store_repository.dart';
import 'package:scholarar/data/repository/course_repository.dart';
import 'package:scholarar/data/repository/home_repository.dart';
import 'package:scholarar/data/repository/language_repository.dart';
import 'package:scholarar/data/repository/scholarship_repository.dart';
import 'package:scholarar/data/repository/test_repository.dart';
import 'package:scholarar/helper/network_info.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {

  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => NetworkInfo(Get.find()));
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => DioClient(appBaseUrl: AppConstants.baseURL, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => LanguageRepository());
  Get.lazyPut(() => AuthRepository(dioClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => TestRepository(dioClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ScholarshipRepository(dioClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => BookStoreRepository(dioClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CourseRepository(dioClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => HomeRepository(dioClient: Get.find(), sharedPreferences: Get.find()));

  // Controller
  Get.lazyPut(() => SplashController());
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find(), dioClient: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthController(authRepository: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => TestController(testRepository: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => BookStoreController(bookStoreRepository: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CourseController(courseRepository: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => HomeController(homeRepository: Get.find(), sharedPreferences: Get.find()));

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
