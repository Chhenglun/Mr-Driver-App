import 'package:get/get_connect/http/src/response/response.dart';
import 'package:scholarar/data/api/api_client.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetBookingRequestRepository{
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  GetBookingRequestRepository({required this.dioClient, required this.sharedPreferences});

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
  Future<Response> getTripInfo({required String tripId}) async {
    try {
      //final response = await dioClient.getData("${AppConstants.getTripInfo}$tripId");
      final response = await dioClient.getData("${AppConstants.getTripInfo}$tripId");
      print(" Endpoint ${AppConstants.getTripInfo}$tripId");
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  //Todo: startTripRepo
  Future startTripRepo(String tripId) async {
    Map<String, dynamic> body = {
      "trip_id": tripId,
    };
    try {
      final response = await dioClient.postData(AppConstants.startTrip, body);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  //Todo: finishTrip
  Future finishTrip(String tripId, List<double> coordinates) async {
    Map<String, dynamic> body = {
      "trip_id": tripId,
      "end_location": {
        "type": "Point",
        "coordinates": [coordinates[0], coordinates[1]], // Ensure latitude is first, longitude is second
      }
    };
    try {
      final response = await dioClient.postData(AppConstants.finishTrip, body);

      // Log the request and response for debugging
      print("Request URL: ${AppConstants.finishTrip}");
      print("Request Body: $body");
      print("Response Status Code: ${response.statusCode}");
      print("Response Data: ${response.body}");

      return response;
    } catch (e) {
      print("Request Error: $e");
      throw e.toString();
    }
  }


}