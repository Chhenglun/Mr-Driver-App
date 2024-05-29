// ignore_for_file: prefer_final_fields

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:scholarar/data/api/api_client.dart';
import 'package:scholarar/data/model/body/auth_model.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  AuthRepository({required this.dioClient, required this.sharedPreferences});

  Future<void> saveUserToken({String? token}) async {
    dioClient.updateHeader(oldToken: token);
    try {
      await sharedPreferences.setString(AppConstants.token, token ?? "");
    } catch (e) {
      throw e.toString();
    }
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  Future<Response> register (String name, String gender,String email, String password,String confirmPassword) async {
    Map<String, String> body = {
      'name' : name,
      "gender": gender,
      // "phone": phoneNumber,
      // "phone_code": "855",
      "email": email,
      "otp_verify_code": "123456",
      "password": password,
      "password_confirmation": confirmPassword,
      "accepted_terms_conditions": "1",
    };
    try {
      Response response = await dioClient.postData(
        AppConstants.register, body,
        headers: {
          'Content-Type': 'application/json',
        }
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> signInWithPhone(AuthModel authModel) async {
    try {
      Response response = await dioClient.postData(AppConstants.phoneSignIn, authModel.toJson());
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  Future<Response> loginWithPhone(String phone, String password, String ) async {
    try {
      Response response = await dioClient.postData(AppConstants.login, {
        'phone': phone,
        'password': password,
      });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  Future<Response> loginWithEmail (String email, String password , String  ) async {
    try {
      Response response = await dioClient.postData(AppConstants.login, {
        'email': email,
        'password': password,
      });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> changeAvatar(String uuid) async {
    try {
      final response = await dioClient.postData(AppConstants.changeAvatar, {'storage_uuid': uuid});
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> uploadAvatar(XFile file) async {
    try {
      final response = await dioClient.postMultipartData(AppConstants.uploadFile, {}, [MultipartBody('file', file)]);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> changeName(String name) async {
    try {
      Response response = await dioClient.postData(AppConstants.changeUserName, {'name': name,});
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> getUserInfo() async {
    try {
      String token = sharedPreferences.getString(AppConstants.token)!;
      dioClient.updateHeader(oldToken: token);
      final response = await dioClient.getData(AppConstants.getUserInfo);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> getSubscription() async {
    try {
      final response = await dioClient.getData(AppConstants.getSubscription);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> clearSharedData() async {
    await sharedPreferences.remove(AppConstants.token);
    return true;
  }

  Future<Response> sendOTP(String phone, String phoneCode) async {
    Map<String, String> body = {
      "phone": phone,
      "phone_code": phoneCode.substring(1)
    };
    try {
      final response = await dioClient.postData(
          AppConstants.sendVerificationSMS, body,
          headers: {'Content-Type': 'application/json'}
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> verifyOtp(String phone, String phoneCode, String otpCode) async {
    Map<String, String> body = {
      "phone": phone,
      "phone_code": phoneCode,
      "verification_code": otpCode
    };
    try {
      final response = await dioClient.postData(
        AppConstants.verificationCode, body,
        headers: {'Content-Type': 'application/json'}
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> signOut(String deviceID) async {
    try {
      final response = await dioClient.postData(
        AppConstants.signOut,
        {
          "device_token": deviceID
        }
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future changePhoneNumber({required String phone, required String phoneCode, required String pin, required String otp}) async{
    try{
      final response = await dioClient.postData(AppConstants.changePhoneNumber, {
        "phone" : phone,
        "phone_code" : phoneCode,
        "pin" : pin,
        "verification_code" : otp
      });
      return response;
    } catch(e){
      throw e.toString();
    }
  }

  Future<Response> createNewPassword({
    required String phone,
    required String phoneCode,
    required String verificationCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    Map<String, String> body = {
      'phone': phone,
      'phone_code': phoneCode,
      "verification_code": verificationCode,
      'new_password': newPassword,
      'confirm_password': confirmPassword
    };
    try {
      final response = await dioClient.postData(AppConstants.resetPassword, body);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> checkPassword(String phone, String phoneCode,String oldPassword) async {
    try {
      final response = await dioClient.postData(
        AppConstants.changePassword,
        {
          'phone': phone,
          'phone_code': phoneCode,
          'old_password': oldPassword,
        }
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> checkCurrentPassword(String currentPassword) async {
    try {
      final response = await dioClient.postData(AppConstants.changePassword, {'current_password': currentPassword});
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    try {
      final response = await dioClient.postData(
        AppConstants.changePassword,
        {
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}


