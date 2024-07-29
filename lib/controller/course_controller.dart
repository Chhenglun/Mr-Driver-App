// ignore_for_file: await_only_futures, avoid_print, unnecessary_null_comparison, prefer_const_constructors, unused_local_variable, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarar/data/repository/course_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseController extends GetxController implements GetxService {
  final CourseRepository courseRepository;
  final SharedPreferences sharedPreferences;
  CourseController({required this.courseRepository, required this.sharedPreferences});

  // set
  bool _isLoading = false;
  bool _isLoadMore = false;
  int _page = 1;
  List? _courseList;
  List? _categoryList;
  List? _popularCourse;
  Map<String, dynamic>? _courseDetailMap;
  final ScrollController _scrollController = ScrollController();

  // get
  bool get isLoading => _isLoading;
  bool get isLoadMore => _isLoadMore;
  int get page => _page;
  List? get courseList => _courseList;
  List? get categoryList => _categoryList;
  List? get popularCourse => _popularCourse;
  Map<String, dynamic>? get courseDetailMap => _courseDetailMap;
  ScrollController? get scrollController => _scrollController;

  setLoadMore(bool more) {
    _isLoadMore = more;
    update();
  }

  setPage(int page) async {
    _page += page;
    update();
  }

  Future<void> scrollListener() async {
    if (isLoadMore &&
        (ScrollController().position.pixels ==
            ScrollController().position.maxScrollExtent)) {
      await getCourse();
    }
  }

  Future<void> getCourse() async {
    try {
      _isLoading = true;
      _isLoadMore = false;
      update();
      Response response = await courseRepository.getCourse("$page");
      if(response.body['status'] == 200) {
        var lists = response.body['data']['lists'];
        print(page);
        if(page == 1) {
          _courseList = [];
          _popularCourse = [];
        }
        lists.forEach((v){
          _courseList?.add(v);
        });
        lists.forEach((v){
          if(v["popular"] == true){
            _popularCourse?.add(v);
          }
        });
        setPage(1);
        if (lists.length >= 20 ){
          _isLoadMore =  true;
          update();
          scrollListener();
          update();
        }
        update();
        print("Loading More");
      } else {
        print("Error: 123");
      }
      _isLoading = false;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future getCategory() async {
    try {
      _isLoading = true;
      update();
      Response response = await await courseRepository.getCategory();
      if(response.body['status'] == 200) {
        _categoryList = response.body['data']['lists'];
        // print("Category List : $categoryList");
      } else {
        print(response.body['message']);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future getCourseDetail ({required int courseId}) async {
    try {
      Response response = await courseRepository.getCourseDetail(courseId: courseId);
      if(response.body['status'] == 200){
        _courseDetailMap = response.body['data'];
      } else {
         print("Error : ${response.body['message']}");
      }
      _isLoading = false;
      update();
    } catch (e) {
      throw e.toString();
    }
  }
}
