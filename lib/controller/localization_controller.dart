// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarar/data/api/api_client.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends GetxController {

  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  LocalizationController({required this.sharedPreferences, required this.dioClient}) {
    loadCurrentNumberLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode);
  bool _isLtr = true;
  int _selectedIndex = 0;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  int get selectedIndex => _selectedIndex;

  // change 3 languages
  void setNumberLanguage(Locale locale, int number){
    Get.updateLocale(locale);
    _locale = locale;
    _selectedIndex = number;
    if (_locale.languageCode == 'ar') {
      _isLtr = false;
    } else {
      _isLtr = true;
    }
    saveNumberLanguage(_locale);
    saveSelectedNumberIndex(_selectedIndex);
    update();
  }

  void loadCurrentNumberLanguage() async {
    _locale = Locale(
      sharedPreferences.getString(AppConstants.languageCode) ?? AppConstants.languages[0].languageCode ?? "en",
      sharedPreferences.getString(AppConstants.countryCode) ?? AppConstants.languages[0].countryCode ?? "en",
    );
    _selectedIndex = sharedPreferences.getInt(AppConstants.isSelectNumber) ?? 0;
    _isLtr = _locale.languageCode != 'ar';
    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (_locale.languageCode == AppConstants.languages[index].languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    update();
  }

  void saveNumberLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstants.countryCode, locale.countryCode!);
  }

  void saveSelectedNumberIndex(int index) async {
    sharedPreferences.setInt(AppConstants.isSelectNumber, index);
  }

  setSelectedNumberIndex(int index) {
    _selectedIndex = index;
    update();
  }
}
