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
  Future updateToken(String deviceToken ,String driverId , List<double> location  ) async {
    Map<dynamic, dynamic> body = {
      "deviceToken": deviceToken,
      "driver_id": driverId,
      "location" : location,
    };
    try {
      final response = await dioClient.postData(AppConstants.updateToken, body);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  //Todo: acceptBooking
  Future acceptBooking(String driverId ,String tripId , List<double> location) async {
    Map<String, dynamic> body = {
      "trip_id": tripId,
      "driver_id": driverId,
      "driver_location": location
    };
    try {
      final response = await dioClient.postData(AppConstants.acceptTrip, body);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  //Todo: resetToken
  /*Future resetToken(String deviceToken ,String driverId) async {
    Map<String, dynamic> body = {
      "deviceToken": deviceToken,
      "driver_id": driverId,

    };
    try {
      final response = await dioClient.postData(AppConstants.resetToken, body);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }*/
  //Todo: deleteToken
Future deleteToken(String driverId) async {
  Map<String, dynamic> body = {
    "driver_id": driverId,
  };
  try {
    final response = await dioClient.putData(
        AppConstants.deleteToken,
        body,
        headers: {
          'Content-Type': 'application/json',
    });
    return response;
  } catch (e) {
    throw e.toString();
  }
}
  //Todo: GetTripInfo
  Future getTripInfo({required String tripId, } ) async {
    try {
      final response = await dioClient.getData(AppConstants.getTripInfo.replaceFirst("{trip_id}", tripId));
      print("end of getTripInfo $response");
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  //Todo: getDripIDRepository
  /*Future getDriverID() async {
    try {
      final response = await dioClient.getData("${AppConstants.getTripID}/");
      return response;
    } catch (e) {
      throw e.toString();
    }
  }*/

}