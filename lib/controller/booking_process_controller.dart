// ignore_for_file: avoid_print

import 'dart:collection';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:scholarar/data/repository/booking_process_repository.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/custom/custom_drop_down_widget.dart';
import 'package:scholarar/view/custom/custom_show_banner.dart';
import 'package:scholarar/view/custom/custom_show_snakbar.dart';
import 'package:scholarar/view/screen/booking/driver_go_to_passenger_screen.dart';
import 'package:scholarar/view/screen/booking/finish_trip.dart';
import 'package:scholarar/view/screen/booking/on_going_screen.dart';
import 'package:scholarar/view/screen/booking/open_booking.dart';
import 'package:scholarar/view/screen/booking/opening_booking.dart';
import 'package:scholarar/view/screen/booking/driver_start_pick_passenger_screen.dart';
import 'package:scholarar/view/screen/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repository/tracking_repository.dart';

class BookingProcessController extends GetxController implements GetxService {
  final GetBookingRequestRepository getBookingRequestController;
  final SharedPreferences sharedPreferences;
  BookingProcessController({required this.getBookingRequestController, required this.sharedPreferences});

  //set
  var _isLoading = false.obs;
  Map<String,dynamic>? _slideShowList;
  List<Map<String, dynamic>>? _driverIDList;
  Map<String, dynamic>? _tripInfo;
  String tripID = '';
  String status = '';
  //Map<String,dynamic>? _driverIDMap;
  // List? _featuredCoursesList;
  // List? _newsList;
  // List? _carouselList;

  //get
  Map<String, dynamic>? get tripInfo => _tripInfo;
  bool get isLoading => _isLoading.value;
  Map<String , dynamic>? get slideShowList => _slideShowList;
  List<Map<String, dynamic>>? get driverIDList => _driverIDList;

  // List? get featuredCoursesList => _featuredCoursesList;
  // List? get newsList => _newsList;
  // List? get carouselList => _carouselList;
  //Todo: update token and save message to local storage
  Future updateToken(String deviceToken, String driverId, List<double> location) async {
    try {
      _isLoading.value = true;
      update();
      Response apiResponse = await getBookingRequestController.updateToken(deviceToken, driverId , location);
      if (apiResponse.statusCode == 200) {
        print("Update Token Success: ${apiResponse.body}");
        customShowTopBanner(Get.context!, "ការបើកទទួលការកក់របស់អ្នកទទួលបានជោគជ័យ", isError: false);
        //Map<String, dynamic> map = apiResponse.body;
      } else if (apiResponse.statusCode == 404) {
        print("Driver not found");
        customShowSnackBar('Driver not found', Get.context!, isError: true);
      } else {
        print("Error updating token: ${apiResponse.body}");
        customShowTopBanner(Get.context!, "មានបញ្ហាកើតឡើង", isError: true);
      }
    } catch (e) {
      print("Error: $e");
      customShowSnackBar('ការបើករការ', Get.context!, isError: true);
      customShowTopBanner(Get.context!, "ការបើកទទួលការកក់របស់អ្នកបរាជ័យ", isError: true);
    } finally {
      _isLoading.value = false;
      update();
    }
  }
  //Todo: update token controller
  Future deleteDeviceToken(String driverId) async {
    try {
      _isLoading.value = true;
      update();
      Response apiResponse = await getBookingRequestController.deleteToken(driverId);
      if (apiResponse.statusCode == 200) {
        print("Delete Token Success: ${apiResponse.body}");
        if (status == 'accepted') {
          await getTripInfo(tripID);
          print("Trip Info: $_tripInfo");
          nextScreen(Get.context!,DriverPickPassenger());
        } else {
          customShowTopBanner(Get.context!, "អ្នកបានបិតការកក់ទទួលបានជោកជ័យ", isError: false);
          nextScreen(Get.context!, OpenBooking());
        }

      } else if (apiResponse.statusCode == 404) {
        print("Driver not found");
        //customShowSnackBar('Driver not found', Get.context!, isError: true);
        customShowTopBanner(Get.context!, "មានបញ្ហាកើតឡើង", isError: true);
      } else {
        customShowSnackBar('Error deleting token', Get.context!, isError: true);
      }
    } catch (e) {
      print("Error: $e");
      //customShowSnackBar('An error occurred', Get.context!, isError: true);
      customShowTopBanner(Get.context!, "ការបិតការកក់របស់អ្នកមិនទទួលលបានជោគជ័យនោះទេ", isError: true);
    } finally {
      _isLoading.value = false;
      update();
    }
  }
  //Todo: acceptBooking Controller
  Future acceptBooking(String driverId, String tripId , List<double> location ) async {
    try {
      _isLoading.value = true;
      update();
      Response apiResponse = await getBookingRequestController.acceptBooking(driverId, tripId , location);
      if (apiResponse.statusCode == 200) {
        print("Accept Booking Success: ${apiResponse.body}");
        customShowTopBanner(Get.context!, "អ្នកបានយល់ព្រមការកក់ដោយជោគជ័យ", isError: false);
        Map<String, dynamic> map = apiResponse.body;
        print("Map: $map");
        tripID = map['trip']['_id'];
        print("Trip ID: $tripID");
        status = map['trip']['status'];
        print("Status Acceptd Booking: $status");
        if (status == 'accepted') {
          // Fetch trip info
          await getTripInfo(tripID);
          // Save message to local storage
          //nextScreenNoReturn(Get.context!, AcceptedScreen());
          nextScreenNoReturn(Get.context, DriverPickPassenger());
          deleteDeviceToken(driverId);
        }else{
          nextScreenNoReturn(Get.context!, OpeningBooking());
        }
      } else if (apiResponse.statusCode == 404) {
        print("Driver not found");
        /*customShowSnackBar('Driver not found', Get.context!, isError: true);*/
        customShowTopBanner(Get.context!, "មានបញ្ហាកើតឡើង", isError: true);
      } else {
        print("Error accepting booking: ${apiResponse.body}");
        /*customShowSnackBar('Error accepting booking', Get.context!, isError: true);*/
        customShowTopBanner(Get.context!, "ការយល់ព្រមការកក់របស់អ្នកបរាជ័យ៉", isError: true);
      }
    } catch (e) {
      print("Error: $e");
      customShowSnackBar('An error occurred', Get.context!, isError: true);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  //Todo: GetTripInfoController
  Future getTripInfo(String tripId) async {
    try {
      _isLoading.value = true;
      update();
      Response apiResponse = await getBookingRequestController.getTripInfo(tripId: tripId);
      if (apiResponse.statusCode == 200) {
        print("Get Trip Info Success: ${apiResponse.body}");
        _tripInfo = apiResponse.body;
       // customShowSnackBar('Get Trip Info Success', Get.context!, isError: false);
        print("Trip Info: $_tripInfo");
      } else if (apiResponse.statusCode == 404) {
        print("Trip Info not found");
        //customShowSnackBar('Trip info not found', Get.context!, isError: true);
      } else {
        print("Error getting trip info: ${apiResponse.body}");
       // customShowSnackBar('Error getting trip info', Get.context!, isError: true);
      }
    } catch (e) {
      print("Error: $e");
      //customShowSnackBar('An error occurred', Get.context!, isError: true);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  //Todo: startTripController
  Future startTrip({required String tripId}) async {
    try {
      _isLoading.value = true;
      update();
      Response apiResponse = await getBookingRequestController.startTripRepo(tripId);
      if (apiResponse.statusCode == 200) {
        print("Start Trip Success: ${apiResponse.body}");
        Map<String, dynamic> map = apiResponse.body;
        await getTripInfo(tripId);
        customShowTopBanner( Get.context!,'សូមការដឹកអ្នកដំណើរប្រកបដោយសុវត្តិភាព', isError: false);
        Get.to(OnGoingScreen());
        print("Start Trip Info: $map");
        print("__________________________________________________________________________________");
      } else if (apiResponse.statusCode == 404) {
        print("Trip not found");
        customShowSnackBar('Trip not found', Get.context!, isError: true);
      } else {
        print("Error starting trip: ${apiResponse.body}");
        customShowSnackBar('Error starting trip', Get.context!, isError: true);
      }
    } catch (e) {
      print("Error: $e");
      customShowSnackBar('An error occurred', Get.context!, isError: true);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  //Todo: finishTripController
  Future finishTripController({required String tripId, required List<double> coordinates}) async {
    try {
      _isLoading.value = true;
      update();

      // Log the request details for debugging
      print("<<<<<<<<<<<<<<< Request Details >>>>>>>>>>>>>>>");
      print("Trip ID: $tripId");
      print("Coordinates: $coordinates");
      print("<<<<<<<<<<<<<<< Request Details >>>>>>>>>>>>>>>");

      Response apiResponse = await getBookingRequestController.finishTrip(tripId, coordinates);

      // Log the response details for debugging
      print("<<<<<<<<<<<<<<< Response Details >>>>>>>>>>>>>>>");
      print("Status Code: ${apiResponse.statusCode}");
      print("Response Data: ${apiResponse.body}");
      print("<<<<<<<<<<<<<<< Response Details >>>>>>>>>>>>>>>");

      if (apiResponse.statusCode == 200) {
        print("Finish Trip Success: ${apiResponse.body}");
        customShowTopBanner(Get.context!, 'អ្នកបានបញ្ចប់ការកក់ដោយជោគជ័យ', isError: false);
        nextScreenNoReturn(Get.context!, OpenBooking());
        Map map = apiResponse.body;
        print("Finish Trip Info: $map");
        String message = map["message"];
        print("map = $message");
        customShowTopBanner(Get.context!, "អ្នកបានបញ្ចប់ការកក់ដោយជោគជ័យ", isError: false);
      } else if (apiResponse.statusCode == 404) {
        print("Trip not found");
        //customShowSnackBar('Trip not found', Get.context!, isError: true);
        customShowTopBanner(Get.context!, "មានបញ្ហាមិនប្រក្រតី", isError: true);
      } else {
        print("Error finishing trip: ${apiResponse.body}");
        //customShowSnackBar('Error finishing trip', Get.context!, isError: true);
        customShowTopBanner(Get.context!, "ការបញប់របស់អ្នកបរាជ័យ", isError: true);
      }
    } catch (e) {
      print("Error: $e");
      //customShowSnackBar('An error occurred', Get.context!, isError: true);
      customShowTopBanner(Get.context!, "ការបញ្ចប់របស់អ្នកមិនទាន់ត្រឹមត្រូវនោះទេ", isError: true);
    } finally {
      _isLoading.value = false;
      update();
    }
  }


}