// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:scholarar/data/repository/get_booking_request.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/custom/custom_show_snakbar.dart';
import 'package:scholarar/view/screen/booking/open_booking.dart';
import 'package:scholarar/view/screen/booking/opening_booking.dart';
import 'package:scholarar/view/screen/booking/tracking.dart';
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
  Map<String, dynamic>? _tripInfo;
  String tripID = '';
  //Map<String,dynamic>? _driverIDMap;
  // List? _featuredCoursesList;
  // List? _newsList;
  // List? _carouselList;

  //get
  Map<String , dynamic>? get tripInfo => _tripInfo;
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
  //Todo: acceptBooking Controller
  Future acceptBooking(String driverId, String tripId , List<double> location ) async {
    try {
      _isLoading = true;
      update();
      Response apiResponse = await getBookingRequestController.acceptBooking(driverId, tripId , location);
      if (apiResponse.statusCode == 200) {
        print("Accept Booking Success: ${apiResponse.body}");
        customShowSnackBar('អ្នកបានយល់ព្រមការកក់ដោយជោគជ័យ', Get.context!, isError: false);
        Map<String, dynamic> map = apiResponse.body;
        print("Map: $map");
        tripID = map['trip']['_id'];
        print("Trip ID: $tripID");
        String status = map['trip']['status'];
        print("Status Acceptd Booking: $status");
        if (status == 'accepted') {
          // Fetch trip info
          await getTripInfo(tripID);
          // Save message to local storage
          nextScreen(Get.context!, TrackingScreen());
        }
      } else if (apiResponse.statusCode == 404) {
        print("Driver not found");
        customShowSnackBar('Driver not found', Get.context!, isError: true);
      } else {
        print("Error accepting booking: ${apiResponse.body}");
        customShowSnackBar('Error accepting booking', Get.context!, isError: true);
      }
    } catch (e) {
      print("Error: $e");
      customShowSnackBar('An error occurred', Get.context!, isError: true);
    } finally {
      _isLoading = false;
      update();
    }
  }

  //Todo: GetTripInfoController
  Future getTripInfo(String tripId) async {
    try {
      _isLoading = true;
      update();
      Response apiResponse = await getBookingRequestController.getTripInfo(tripId: tripId);
      if (apiResponse.statusCode == 200) {
        print("Get Trip Info Success: ${apiResponse.body}");
        _tripInfo = apiResponse.body;
        customShowSnackBar('Get Trip Info Success', Get.context!, isError: false);
        print("Trip Info: $_tripInfo");
      } else if (apiResponse.statusCode == 404) {
        print("Trip Info not found");
        customShowSnackBar('Trip info not found', Get.context!, isError: true);
      } else {
        print("Error getting trip info: ${apiResponse.body}");
        customShowSnackBar('Error getting trip info', Get.context!, isError: true);
      }
    } catch (e) {
      print("Error: $e");
      customShowSnackBar('An error occurred', Get.context!, isError: true);
    } finally {
      _isLoading = false;
      update();
    }
  }
}