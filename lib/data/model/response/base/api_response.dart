import 'package:get/get_connect/http/src/response/response.dart';

class ApiResponse {
  final Response? response;
  final dynamic error;
  ApiResponse(this.response, this.error);
  ApiResponse.withError(dynamic errorValue): response = null, error = errorValue;
  ApiResponse.withSuccess(Response responseValue): response = responseValue, error = null;
}

// generate json serializable
class ResponseModel<T> {
  int? status;
  String? message;
  T? data;

  ResponseModel({this.status, this.message, this.data});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if(data != null) {
      data = json['data'];
    }
  }
}

class ResponseList<T> {
  final List<T>? list;
  final Pages? pages;
  ResponseList({this.list, this.pages});

  ResponseList.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) :
    list = json['data'] != null ? List<T>.from(json['data'].map((dynamic item) => fromJson(item))) : null,
    pages = json['pages'] != null ? Pages.fromJson(json['pages']) : null;
}

class Pages {
  int? total;
  int? limit;
  int? page;

  Pages({this.total, this.limit, this.page});

  Pages.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    page = json['page'];
  }
}