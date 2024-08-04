// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:scholarar/data/repository/get_booking_request.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/custom/custom_show_snakbar.dart';
import 'package:scholarar/view/screen/booking/open_booking.dart';
import 'package:scholarar/view/screen/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repository/tracking_repository.dart';

class GetBookingRequestController extends GetxController implements GetxService {
  final GetBookingRequestRepository getBookingRequestController;
  final SharedPreferences sharedPreferences;
  GetBookingRequestController({required this.getBookingRequestController, required this.sharedPreferences});

  //set
  bool _isLoading = false;
  Map<String,dynamic>? _slideShowList;
  List<Map<String, dynamic>>? _driverIDList;
  //Map<String,dynamic>? _driverIDMap;
  // List? _featuredCoursesList;
  // List? _newsList;
  // List? _carouselList;

  //get
  bool get isLoading => _isLoading;
  Map<String , dynamic>? get slideShowList => _slideShowList;
  List<Map<String, dynamic>>? get driverIDList => _driverIDList;

  // List? get featuredCoursesList => _featuredCoursesList;
  // List? get newsList => _newsList;
  // List? get carouselList => _carouselList;
  //Todo: Get Request
  Future getRequest() async {
    try {
      _isLoading = true;
      Response response = await getBookingRequestController.getBooking(

      );
      if(response.statusCode == 200) {
        _slideShowList = response.body['start_location'];
        print("Get Data booking Success {$_slideShowList}");
      } else {
        print("Error");
      }
    } catch (e) {
      throw e.toString();
    }
  }
  //Todo: resetToken and save message to local storage
  /*Future resetToken(String deviceToken, String driverId) async {
    try {
      _isLoading = true;
      update();
      Response apiResponse = await getBookingRequestController.resetToken(deviceToken, driverId);
      if (apiResponse.statusCode == 200) {
        print("Reset Token Success: ${apiResponse.body}");
        //nextScreen(context, page)
        customShowSnackBar('ការបើកទទួលការកក់របស់អ្នកទទួលបានជោគជ័យ', Get.context!, isError: false);
        Map<String, dynamic> map = apiResponse.body;
       *//* try {
          // Save message to local storage
          await sharedPreferences.setString(AppConstants.message, map['message']);
        } catch (e) {
          print("Error: $e");
          customShowSnackBar('An error occurred', Get.context!, isError: true);
        }*//*
      } else if (apiResponse.statusCode == 404) {
        print("Driver not found");
        customShowSnackBar('Driver not found', Get.context!, isError: true);
      } else {
        print("Error updating token: ${apiResponse.body}");
        customShowSnackBar('Error updating token', Get.context!, isError: true);
      }
    } catch (e) {
      print("Error: $e");
      customShowSnackBar('An error occurred', Get.context!, isError: true);
    } finally {
      _isLoading = false;
      update();
    }
  }*/
  //Todo: update token and save message to local storage
  Future updateToken(String deviceToken, String driverId, List<double> location) async {
    try {
      _isLoading = true;
      update();
      Response apiResponse = await getBookingRequestController.updateToken(deviceToken, driverId , location);
      if (apiResponse.statusCode == 200) {
        print("Update Token Success: ${apiResponse.body}");
        customShowSnackBar('ការបើកទទួលការកក់របស់អ្នកទទួលបានជោគជ័យ', Get.context!, isError: false);
        Map<String, dynamic> map = apiResponse.body;
      } else if (apiResponse.statusCode == 404) {
        print("Driver not found");
        customShowSnackBar('Driver not found', Get.context!, isError: true);
      } else {
        print("Error updating token: ${apiResponse.body}");
        customShowSnackBar('Error updating token', Get.context!, isError: true);
      }
    } catch (e) {
      print("Error: $e");
      customShowSnackBar('An error occurred', Get.context!, isError: true);
    } finally {
      _isLoading = false;
      update();
    }
  }
  //Todo: update token controller
  Future deleteDeviceToken(String driverId) async {
    try {
      _isLoading = true;
      update();
      Response apiResponse = await getBookingRequestController.deleteToken(driverId);
      if (apiResponse.statusCode == 200) {
        print("Delete Token Success: ${apiResponse.body}");
        customShowSnackBar('Token deleted successfully', Get.context!, isError: false);
        nextScreen(Get.context!, OpenBooking());
      } else if (apiResponse.statusCode == 404) {
        print("Driver not found");
        customShowSnackBar('Driver not found', Get.context!, isError: true);
      } else {
        customShowSnackBar('Error deleting token', Get.context!, isError: true);
      }
    } catch (e) {
      print("Error: $e");
      customShowSnackBar('An error occurred', Get.context!, isError: true);
    } finally {
      _isLoading = false;
      update();
    }
  }
  /*//Todo: Update Token Controller

  Future updateToken(String deviceToken ,String driverId) async {
    try {
      _isLoading = true;
      update();
      Response apiResponse = await getBookingRequestController.updateToken(deviceToken, driverId);
      if (apiResponse.statusCode == 200) {
        print("Update Token Success: ${apiResponse.body}");
        customShowSnackBar('ការបើកទទួលការកក់របស់អ្នកទទួលបានជោគជ័យ', Get.context!, isError: false);
        Map map = apiResponse.body;
        try {
          //save message to local storage
          await sharedPreferences.setString(AppConstants.message, map['message']);
        } catch (e) {
          print("Error: $e");
          customShowSnackBar('An error occurred', Get.context!, isError: true);
        }
      } else if (apiResponse.statusCode == 404) {
        print("Driver not found");
        customShowSnackBar('Driver not found', Get.context!, isError: true);
      } else {
        print("Error updating token: ${apiResponse.body}");
        customShowSnackBar('Error updating token', Get.context!, isError: true);
      }
    } catch (e) {
      print("Error: $e");
      customShowSnackBar('An error occurred', Get.context!, isError: true);
    } finally {
      _isLoading = false;
      update();
    }
  }*/

  //Todo: Get Driver ID
  /*Future getDriverID() async {
    try {
      _isLoading = true;
      update();
      Response response = await getBookingRequestController.getDriverID();
      if (response.statusCode == 200) {
        List<dynamic> data = response.body;
        _driverIDList = List<Map<String, dynamic>>.from(
            data.map((item) => item as Map<String, dynamic>));
        print("Get Data booking Success: $_driverIDList");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      _isLoading = false;
      update();
    }
  }*/
}