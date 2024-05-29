import 'package:scholarar/data/api/api_client.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookStoreRepository{
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  BookStoreRepository({required this.dioClient, required this.sharedPreferences});

  // TODO: GetBookStore
  Future getBookStore(String page) async {
    try {
      final response = await dioClient.getData("${AppConstants.getBookStore}/?page=$page");
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  // TODO: GetBookDetail
  Future getBookDetail({required int bookId}) async {
    try {
      final response = await dioClient.getData("${AppConstants.getBookStore}/$bookId");
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}