// ignore_for_file: await_only_futures, avoid_print, unnecessary_null_comparison, prefer_const_constructors, unused_local_variable, deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:scholarar/data/model/body/auth_model.dart';
import 'package:scholarar/data/repository/auth_repository.dart';
import 'package:scholarar/helper/token_helper.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/loading_dialog.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/custom/custom_show_snakbar.dart';
import 'package:scholarar/view/screen/account/login_screen.dart';
import 'package:scholarar/view/screen/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController implements GetxService {

  final AuthRepository authRepository;
  late final SharedPreferences sharedPreferences;
  final TokenHelper _tokenHelper = TokenHelper();
  AuthController({required this.authRepository, required this.sharedPreferences});

  // deviceInfo
  String? deviceName;
  String? deviceToken;
  String? pushToken;
  String? location;
  String? country;
  String? ipAddress;
  int? pushChannel;

  //set newb
  bool _isFirstName = false;
  bool _isLastName = false;
  bool _isGender = false;
  bool _isPhoneNumber = false;
  bool _isEmail = false;
  bool _isPassword = false;
  bool _isConfirmPassword = false;
  bool _isAgree = false;
  bool _isEnableVerificationCode = false;

  // set
  bool _isLoading = false;
  bool _isTypingCompleted = false;
  bool _userName = false;
  String _verificationCode = "";
  List? _subscriptionList;
  PickedFile? _pickedImage;
  File? _file;

  // get new
  bool get isFirstName => _isFirstName;
  bool get isLastName => _isLastName;
  bool get isGender => _isGender;
  bool get isPhoneNumber => _isPhoneNumber;
  bool get isEmail => _isEmail;
  bool get isPassword => _isPassword;
  bool get isConfirmPassword => _isConfirmPassword;
  bool get isAgree => _isAgree;
  Map<String, dynamic>? _userInfoMap;

  //get
  bool get isLoading => _isLoading;
  bool get isTypingCompleted => _isTypingCompleted;
  bool get userName => _userName;
  List? get subscriptionList => _subscriptionList;
  Map<String, dynamic>? get userInfoMap => _userInfoMap;
  bool get isEnableVerificationCode => _isEnableVerificationCode;
  String get verificationCode => _verificationCode;
  PickedFile? get pickedImage => _pickedImage;
  File? get file => _file;

  final hidePassword = true.obs;
  final email = TextEditingController(); // Controller for email input
  final lastName = TextEditingController(); // Controller for last name input
  final username = TextEditingController(); // Controller for username input
  final password = TextEditingController(); // Controller for password input
  final firstName = TextEditingController(); // Controller for first name input
  final phoneNumber = TextEditingController(); // Controller for phone number input
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>(); // Form key for form validation

  String token = "";
  final String key = "secure_basicInfo_key";
  static const String noCache = "noCache";

  setTypingCompleted(bool isCompleted) {
    _isTypingCompleted = isCompleted;
    update();
  }

  setUserName(bool userName) {
    _userName = userName;
    update();
  }

  setPassword(bool isPassword) {
    _isPassword = isPassword;
    update();
  }

  setConfirmPassword(bool isConfirmPassword) {
    _isConfirmPassword = isConfirmPassword;
    update();
  }

  updateVerificationCode(String query) {
    if (query.length == 6) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    update();
  }

  void setCache({required String token}) async {
    const storage = FlutterSecureStorage();
    storage.write(key: "token", value: token);
  }

  Future<String> getCache() async {
    const storage = FlutterSecureStorage();
    String? content = await storage.read(key: "token");
    return content ?? noCache;
  }

  Future<void> isCheckToken({context, page}) async {
    try {
      String token = sharedPreferences.getString(AppConstants.token)!;
      if(token.isNotEmpty) {
        print("Hello Profile Token $token");
        nextScreen(context, page);
      } else {
        print("No Token :");
        nextScreen(context, LoginScreen());
      }
    } catch (e) {
      nextScreen(context, LoginScreen());
    }
  }

//Todo : GetIPNetwork
  Future<void> getNetworkIP() async {
    try {
      _isLoading = true;
      update();
      var response = await http.get(Uri.parse('https://api.ipify.org'));
      if (response.statusCode == 200) {
        ipAddress = response.body;
        _isLoading = false;
        update();
      } else {
        throw Exception('Failed to get network IP');
      }
      _isLoading = false;
      update();
    } catch (e) {
      print(e.toString());
      _isLoading = false;
      update();
    }
  }

  // Todo: phoneSignIn
  Future phoneSignIn(AuthModel authModel, context) async {
    loadingDialogs(context);
    try {
      _isLoading = true;
      Response apiResponse = await authRepository.signInWithPhone(authModel);
      if (apiResponse.statusCode == 200) {
        if (apiResponse.body['message'] == "OK") {
          Navigator.pop(context);
          Map map = apiResponse.body;
          try {
            token = map['data']["token"];
          } catch (e) {
            print(e.toString());
          }
          if (token != null && token.isNotEmpty) {
            authRepository.saveUserToken(token: token);
          }
        } else {
          customShowSnackBar("${apiResponse.body['message']}".tr, context);
          Navigator.pop(context);
        }
      } else {
        customShowSnackBar("serverDown".tr, context);
        Navigator.pop(context);
      }
      _isLoading = false;
      update();
    } catch (e) {
      print(e.toString());
      _isLoading = false;
      update();
    }
  }

  Future loginWithPhone(BuildContext context, {required String phone , required String password}) async {
    loadingDialogs(Get.context!);
    try {
      _isLoading = true;
      update();
      Response apiResponse = await authRepository.loginWithPhone(phone, password,context);
      if(apiResponse.body['status'] == 200){
        print("Hello World: ${apiResponse.body['message']}");
        if(apiResponse.body['message'] == "OK"){
          Navigator.pop(Get.context!);
          Map map = apiResponse.body;
          try{
            token = map['data']["token"];
          } catch(e){
            print(e.toString());
          }
          if(token != null && token.isNotEmpty){
            authRepository.saveUserToken(token: token);
          }
        } else {
          customShowSnackBar("${apiResponse.body['message']}".tr, context);
          Navigator.pop(context);
        }
      } else {
        customShowSnackBar("serverDown".tr, context);
        Navigator.pop(context);
      }
    }catch(e){
      print(e.toString());
      _isLoading = false;
      update();
    }
  }

  //Todo : LoginWithEmail
  Future loginWithEmail(BuildContext context, {required String email,  required String password}) async{
    loadingDialogs(Get.context!);
    try{
      _isLoading = true;
      update();
      Response apiResponse = await authRepository.loginWithEmail(email, password, context);
      if(apiResponse.body['status'] == 200){
        if(apiResponse.body['message'] == "OK"){
          Navigator.pop(Get.context!);
          Map map = apiResponse.body;
          try{
            token = map['data']["token"];
          } catch(e){
            print(e.toString());
          }
          if(token != null && token.isNotEmpty){
            await _tokenHelper.saveToken(token: token).then((_) async {
              nextScreenNoReturn(Get.context!, SplashScreen());
            });
          }
          _isLoading = false;
          update();
        } else {
          customShowSnackBar("${apiResponse.body['message']}".tr, Get.context!);
          Navigator.pop(Get.context!);
        }
      } else {
        customShowSnackBar("${apiResponse.body['message']}".tr, Get.context!);
        Navigator.pop(Get.context!);
      }
    } catch(e){
      print("Error B");
      print(e.toString());
      _isLoading = false;
      update();
    }
  }

  // Todo: RegisterController
  Future registerController(BuildContext context,{required String name, required String gender, required String email, required String password, required String confirmPassword  }) async {
    try {
      _isLoading = true;
      update();
      Response apiResponse = await authRepository.register(name,gender, email, password, confirmPassword);
      if (apiResponse.body['status'] == 200 && apiResponse.body['message'] == "OK") {
        print("Register Success : ${apiResponse.body['message']}");
        Map map = apiResponse.body;
        String message = '';
        try {
          message = map["message"];
        } catch (e) {
          print(e.toString());
        }
        try {
          token = map['data']["token"];
        } catch (e) {
          print(e.toString());
        }
        if (token != null && token.isNotEmpty) {
          _tokenHelper.saveToken(token: token);
        }
        customShowSnackBar('successfulCreateAccount'.tr, Get.context!, isError: false);
        await _tokenHelper.saveToken(token: token).then((_) async {
          nextScreenNoReturn(Get.context!, SplashScreen());
        });
      } else {
        customShowSnackBar('thePhoneHasAlreadyBeenTaken'.tr, Get.context!, isError: true);
        if (apiResponse.hasError is String) {
          _isLoading = false;
          update();
        } else {
          _isLoading = false;
          update();
        }
      }
      _isLoading = false;
      update();
    } catch (e) {
      print(e.toString());
      _isLoading = false;
      update();
    }
  }

  // Todo: signOut
  Future signOut(context) async {
    try {
      _isLoading = true;
      update();
      await _tokenHelper.clearStorage().then((_){
        _userInfoMap = null;
        update();
        print("Sign Out");
        print("User Info : $_userInfoMap");
        nextScreenNoReturn(context, SplashScreen());
      });
      _isLoading = false;
      update();
    } catch (e){
      print(e.toString());
      _isLoading = false;
      update();
    }
  }

  // Todo: getUserInfo
  Future getUserInfo() async {
    try {
      _isLoading = true;
      Response apiResponse = await authRepository.getUserInfo();
      if (apiResponse.body['status'] == "success") {
        _userInfoMap = apiResponse.body['data'];
        print("User Info : $_userInfoMap");
        _isLoading = false;
        update();
      } else {
        _userInfoMap = null;
        _isLoading = false;
        update();
      }
      _isLoading = false;
      update();
    } catch (e) {
      print(e.toString());
      _isLoading = false;
      update();
    }
  }

  //Todo: getSubscriptionList
  Future getSubscriptionList() async {
    try {
      _isLoading = true;
      update();
      Response response = await authRepository.getSubscription();
      if (response.body['status'] == 200) {
        print("getSubscription");
        _subscriptionList = response.body['data']['lists'];
        _isLoading = false;
        update();
      } else {
        print("getSubscriptionError");
        _isLoading = false;
        update();
      }
    } catch (e) {
      print("getSubscriptionCatch");
      throw e.toString();
    }
  }
}
