import 'package:scholarar/data/api/api_client.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseRepository{
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  CourseRepository({required this.dioClient, required this.sharedPreferences});

  //TODO: GetAllCourse
  Future getCourse(String page) async {
    try {
      final response = await dioClient.getData("${AppConstants.getCourse}/?page=$page");
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  //TODO: GetCategoryCourse
  Future getCategory() async {
    try {
      final response = await dioClient.getData(AppConstants.getCategory);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  //TODO: GetCourseDetail
  Future getCourseDetail({required int courseId}) async {
    try {
      final response = await dioClient.getData("${AppConstants.getCourse}/$courseId");
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}