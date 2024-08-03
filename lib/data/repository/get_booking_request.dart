import 'package:scholarar/data/api/api_client.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetBookingRequestRepository{
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  GetBookingRequestRepository({required this.dioClient, required this.sharedPreferences});

  // TODO: GetBookStore
  Future getBooking() async {
    try {
      final response = await dioClient.getData("${AppConstants.getBookingRequest}/");
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  //Todo: updateToken
  Future updateToken(String deviceToken ,String driverId) async {
    Map<String, dynamic> body = {
      "deviceToken": deviceToken,
      "driver_id": driverId,
    };
    try {
      final response = await dioClient.postData(AppConstants.updateToken, body);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  //Todo: getDripIDRepository
  Future getDriverID() async {
    try {
      final response = await dioClient.getData("${AppConstants.getTripID}/");
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

}