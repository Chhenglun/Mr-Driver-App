//ignore_for_file: prefer_final_fields

import 'package:scholarar/data/api/api_client.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestRepository {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  TestRepository({required this.dioClient, required this.sharedPreferences});

  Future getTestAPI() async {
    try {
      final response = await dioClient.getData(AppConstants.testAPI);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future getTestAPI2() async {
    try {
      final response = await dioClient.getData(AppConstants.testAPI2);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future getTestCourseAPI() async {
    try {
      final response = await dioClient.getData(AppConstants.testCourseAPI);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future getTestNewAPI () async {
    try {
      final response = await dioClient.getData(AppConstants.testNewAPI);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future getTestScholarshipAPI() async {
    try {
      final response = await dioClient.getData(AppConstants.getScholarship);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  Future getTestCategoryVideoAPI() async {
    try {
      final response = await dioClient.getData(AppConstants.testVideoAPI);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}

