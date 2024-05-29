// ignore_for_file: await_only_futures, avoid_print, unnecessary_null_comparison, prefer_const_constructors, unused_local_variable, deprecated_member_use

import 'package:get/get.dart';
import 'package:scholarar/data/model/TESTAPI/product_model.dart';
import 'package:scholarar/data/model/TESTAPI/rest_test_api_model.dart';
import 'package:scholarar/data/model/TESTAPI/user_model.dart';
import 'package:scholarar/data/repository/test_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestController extends GetxController implements GetxService {
  final TestRepository testRepository;
  final SharedPreferences sharedPreferences;
  TestController({required this.testRepository, required this.sharedPreferences});

  // set
  bool _isLoading = false;
  List? _testAPI;
  List? _testVideoAPI;
  Map<String, dynamic>? _testCourseAPI;
  Map<String, dynamic>? _mapResult;
  Map<String, dynamic>? _testNewAPI;
  Map<String, dynamic>? _testScholarshipAPI;

  //set use model
  List<ProductModel>? _productModel;
  List<UserModel>? _userModel;
  List<RestTestAPIModel>? _restTestAPIModel;

  // get
  bool get isLoading => _isLoading;
  List? get testAPI => _testAPI;
  List? get testVideoAPI => _testVideoAPI;
  Map<String, dynamic>? get testNewAPI => _testNewAPI;
  Map<String, dynamic>? get testCourseAPI => _testCourseAPI;
  Map<String, dynamic>? get mapResult => _mapResult;
  Map<String, dynamic>? get testScholarshipAPI => _testScholarshipAPI;

  //get use model
  List<ProductModel>? get productModel => _productModel;
  List<RestTestAPIModel>? get restTestAPIModel => _restTestAPIModel;
  List<UserModel>? get userModel => _userModel;

  Future getTestAPI() async {
    try {
      _isLoading = true;
      update();
      Response response = await testRepository.getTestAPI();
      if(response.body['code'] == 200) {
        _productModel = List<ProductModel>.from(response.body.map((x) => ProductModel.fromJson(x)));
      } else {
        print("Error");
      }
      _isLoading = false;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future getTestAPI2() async {
    try{
      _isLoading = true;
      update();
      Response response = await testRepository.getTestAPI2();
      if(response.statusCode == 200) {
        _userModel = List<UserModel>.from(response.body.map((x) => UserModel.fromJson(x)));
      } else {
        print("Error");
      }
      _isLoading = false;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future getTestCourseAPI() async {
    try {
      _isLoading = true;
      update();
      Response response = await testRepository.getTestCourseAPI();
      if(response.statusCode == 200) {
         _testCourseAPI = response.body;
        print("TestCourseAPI : $_testCourseAPI");
      } else {
        print("Error");
      }
      _isLoading = false;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future getTestNewAPI() async {
    try {
      _isLoading = true;
      update();
      Response response = await testRepository.getTestNewAPI();
      if(response.statusCode == 200) {
        _testNewAPI = response.body;
      } else {
        print("Error");
      }
      _isLoading = false;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future getTestScholarshipAPI() async {
    try {
      _isLoading = true;
      update();
      Response response = await testRepository.getTestScholarshipAPI();
      if(response.statusCode == 200) {
        _testScholarshipAPI = response.body;
      } else {
        print("Error");
      }
      _isLoading = false;
      update();
    } catch (e) {
      print(e);
    }
  }

  // Future getTestBookAPI() async {
  //   try {
  //     _isLoading = true;
  //     update();
  //     Response response = await testRepository.getTestBookAPI();
  //     if(response.statusCode == 200) {
  //       _testBookAPI = (response.body["data"] as List).map((x) => Item.fromJson(x)).toList();
  //     } else {
  //       print("Error");
  //     }
  //     await Future.delayed(Duration(seconds: 2));
  //     _isLoading = false;
  //     update();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future getTestCategoryVideoAPI() async {
    try {
      _isLoading = true;
      update();
      Response response = await testRepository.getTestCategoryVideoAPI();
      if(response.statusCode == 200) {
        _testVideoAPI = response.body["data"];
        print("TestVideoAPI : $_testVideoAPI");
      } else {
        print("test show error");
      }
      _isLoading = false;
      update();
    } catch (e) {
      print(e);
    }
  }
}
