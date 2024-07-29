import 'package:flutter/material.dart';
import 'package:scholarar/data/model/response/language_model.dart';
import 'package:scholarar/util/app_constants.dart';

class LanguageRepository {
  List<LanguageModel> getAllLanguages({required BuildContext context}) {
    return AppConstants.languages;
  }
}