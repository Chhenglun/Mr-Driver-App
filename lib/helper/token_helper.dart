// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:scholarar/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class TokenHelper {
  final storage = FlutterSecureStorage();
  final SharedPreferences sharedPreferences = Get.find();
  Future<void> saveToken({required String token}) async {
    final SharedPreferences sharedPreferences = Get.find();
    await storage.deleteAll();
    await sharedPreferences.remove(AppConstants.token);
    await storage.write(key: 'token', value: token);
    await sharedPreferences.setString(AppConstants.token, token);
  }

  Future<void> saveUUID({required String uuid}) async {
    await storage.deleteAll();
    await storage.write(key: 'uuid', value: uuid);
  }

  static List<String> convertStringToListString({required String data}) {
    return json.decode(data);
  }

  Future<String?> getToken() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      await sharedPreferences.setString(AppConstants.token, token);
      return token;
    } else
      return null;
  }

  Future<String?> getUUID() async {
    String? uuid = await storage.read(key: 'uuid');
    if (uuid != null) {
      return uuid;
    } else
      return null;
  }

  Future<void> removeToken({bool isNotSignOut = true}) async {
    await storage.deleteAll();
    await sharedPreferences.remove(AppConstants.token);
    return;
  }

  Future<void> clearStorage() async {
    await storage.deleteAll();
    await sharedPreferences.remove(AppConstants.token);
    return;
  }

}