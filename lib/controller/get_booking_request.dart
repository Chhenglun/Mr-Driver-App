// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:scholarar/data/repository/get_booking_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repository/tracking_repository.dart';

class GetBookingRequestController extends GetxController implements GetxService {
  final GetBookingRequestRepository getBookingRequest;
  final SharedPreferences sharedPreferences;
  GetBookingRequestController({required this.getBookingRequest, required this.sharedPreferences});

  //set
  bool _isLoading = false;
  Map<String,dynamic>? _slideShowList;
  // List? _featuredCoursesList;
  // List? _newsList;
  // List? _carouselList;

  //get
  bool get isLoading => _isLoading;
  Map<String , dynamic>? get slideShowList => _slideShowList;
  // List? get featuredCoursesList => _featuredCoursesList;
  // List? get newsList => _newsList;
  // List? get carouselList => _carouselList;

  Future getRequest() async {
    try {
      _isLoading = true;
      Response response = await getBookingRequest.getBooking();
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
}