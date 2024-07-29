// ignore_for_file: prefer_collection_literals

class AuthModel {
  String? id;
  String? uuid;
  String? name;
  String? email;
  String? phoneCode;
  String? phone;
  String? verificationCode;
  String? statusText;
  String? avatarUrl;
  String? language;
  String? password;
  String? newPassword;
  String? confirmPassword;

  AuthModel({
    this.id,
    this.uuid,
    this.name,
    this.email,
    this.phoneCode,
    this.phone,
    this.verificationCode,
    this.statusText,
    this.avatarUrl,
    this.language,
    this.password,
    this.newPassword,
    this.confirmPassword
  });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['uuid'] = uuid;
    data['name'] = name;
    data['email'] = email;
    data['phone_code'] = phoneCode;
    data['phone'] = phone;
    data['verification_code'] = verificationCode;
    data['status_text'] = statusText;
    data['avatar_url'] = avatarUrl;
    data['language'] = language;
    data['password'] = password;
    data['new_password'] = newPassword;
    data['confirm_password'] = confirmPassword;
    return data;
  }
}