//ignore_for_file: prefer_final_fields


import 'package:scholarar/data/api/api_client.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScholarshipRepository {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  ScholarshipRepository({required this.dioClient, required this.sharedPreferences});

  Future getScholarship() async {
    try {
      final response = await dioClient.getData(AppConstants.getScholarship);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future getDegrees() async{
    try {
      final response = await dioClient.getData(AppConstants.getDegrees);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future getScholarshipList ({required int degreeId}) async {
    try {
      final response = await dioClient.getData("${AppConstants.getScholarshipList}$degreeId");
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future getDetailScholarship({required int scholarshipId}) async{
    try {
      final response = await dioClient.getData("${AppConstants.getScholarship}/$scholarshipId");
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future getCountry() async {
    try {
      final response = await dioClient.getData(AppConstants.getCountry);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}

