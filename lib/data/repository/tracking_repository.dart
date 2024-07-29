import 'package:dio/dio.dart';
import 'package:scholarar/data/api/api_client.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingRepository {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  TrackingRepository({required this.dioClient, required this.sharedPreferences});

  Future getTracking() async {
    try {
      final response = await dioClient.getData(AppConstants.google_key_api);

      // Handle the response appropriately
      if (response.statusCode == 200) {
        // Assuming the response data is in JSON format and needs to be parsed
        // return response.data;
      } else {
        // Handle other status codes appropriately
        throw Exception('Failed to load tracking data: ${response.statusCode}');
      }
    } on DioError catch (dioError) {
      // Handle Dio-specific errors
      if (dioError.response != null) {
        throw Exception('Dio error: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}');
      } else {
        throw Exception('Dio error: ${dioError.message}');
      }
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }
}
