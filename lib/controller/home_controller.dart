// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:scholarar/data/repository/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController implements GetxService {
  final HomeRepository homeRepository;
  final SharedPreferences sharedPreferences;
  HomeController({required this.homeRepository, required this.sharedPreferences});

  //set
  bool _isLoading = false;
  List? _slideShowList;
  List? _featuredCoursesList;
  List? _newsList;
  List? _carouselList;

  //get
  bool get isLoading => _isLoading;
  List? get slideShowList => _slideShowList;
  List? get featuredCoursesList => _featuredCoursesList;
  List? get newsList => _newsList;
  List? get carouselList => _carouselList;

  Future getHomeData() async {
    try {
      _isLoading = true;
      Response response = await homeRepository.getHomeData();
      if(response.body['status'] == 200) {
        _slideShowList = response.body['data']['slide_show']['slide_show_details'];
        _featuredCoursesList = response.body['data']['featured_courses'];
        _newsList = response.body['data']['news'];
        _carouselList = response.body['data']['carousel'];
        print("Get Data Home Screen Success");
      } else {
        print("Error");
        print(response.body['message']);
      }
    } catch (e) {
      throw e.toString();
    }
  }
}