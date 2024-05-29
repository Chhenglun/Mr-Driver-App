// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_if_null_operators, prefer_const_constructors, avoid_print,

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:scholarar/data/model/response/base/error_response.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import 'package:path/path.dart' show basename;
import 'package:http_parser/http_parser.dart' show MediaType;

class DioClient extends GetxService {
  final String? appBaseUrl;
  final SharedPreferences sharedPreferences;
  static const String noInternetMessage =
      'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;
  String? token;
  Map<String, String>? _mainHeaders;

  DioClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.token);
    updateHeader(oldToken: '$token');
  }

  void updateHeader({String? oldToken}) {
    _mainHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $oldToken',
    };
  }

  Future<Response> getData(String uri, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      http.Response _response = await http
          .get(
            Uri.parse(appBaseUrl! + uri),
            headers: headers == null ? _mainHeaders : headers,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> getDataQR(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      http.Response _response = await http
          .post(
            Uri.parse(appBaseUrl! + uri),
            body: jsonEncode(body),
            headers: _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      http.Response _response = await http
          .post(
            Uri.parse(appBaseUrl! + uri),
            body: jsonEncode(body),
            headers: _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(
      String uri, Map<String, String> body, List<MultipartBody> multipartBody,
      {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      http.MultipartRequest _request =
          http.MultipartRequest('POST', Uri.parse(appBaseUrl! + uri));
      _request.headers.addAll(headers ?? _mainHeaders!);
      for (MultipartBody multipart in multipartBody) {
        if (foundation.kIsWeb) {
          Uint8List _list = await multipart.file.readAsBytes();
          http.MultipartFile _part = http.MultipartFile(
            multipart.key,
            multipart.file.readAsBytes().asStream(),
            _list.length,
            filename: basename(multipart.file.path),
            contentType: MediaType('image', 'jpg'),
          );
          _request.files.add(_part);
        } else {
          File _file = File(multipart.file.path);
          _request.files.add(
            http.MultipartFile(
              multipart.key,
              _file.readAsBytes().asStream(),
              _file.lengthSync(),
              filename: _file.path.split('/').last,
            ),
          );
        }
      }
      _request.fields.addAll(body);
      http.Response _response =
          await http.Response.fromStream(await _request.send());
      return handleResponse(_response, uri);
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      http.Response _response = await http
          .put(
            Uri.parse(appBaseUrl! + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri,
      {Map<String, String>? headers, body}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      http.Response _response = await http
          .delete(
            Uri.parse(appBaseUrl! + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(http.Response response, String uri) {
    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    } catch (e) {
      print(e.toString());
    }
    Response _response = Response(
      body: _body != null ? _body : response.body,
      bodyString: response.body.toString(),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (_response.statusCode != 200 &&
        _response.body != null &&
        _response.body is! String) {
      if (_response.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse _errorResponse = ErrorResponse.fromJson(_response.body);
        _response = Response(
            statusCode: _response.statusCode,
            body: _response.body,
            statusText: _errorResponse.errors![0].message);
      } else if (_response.body.toString().startsWith('{message')) {
        _response = Response(
            statusCode: _response.statusCode,
            body: _response.body,
            statusText: _response.body['message']);
      }
    } else if (_response.statusCode != 200 && _response.body == null) {
      _response = Response(statusCode: 0, statusText: noInternetMessage);
    }
    debugPrint(
        '====> API Response: [${_response.statusCode}] $uri\n${_response.body}');
    return _response;
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
