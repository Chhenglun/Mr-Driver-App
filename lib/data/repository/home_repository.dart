

import 'package:scholarar/data/api/api_client.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepository {

  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  HomeRepository({required this.dioClient, required this.sharedPreferences});

  Future getHomeData() async {
    try {
      final response = await dioClient.getData(AppConstants.getHomeData);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}