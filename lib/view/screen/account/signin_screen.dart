// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/app/app_screen.dart';
import 'package:scholarar/view/custom/custom_button_widget.dart';
import 'package:scholarar/view/custom/custom_textfield_widget.dart';
import 'package:scholarar/view/screen/account/forget_password_screen.dart';
import 'package:scholarar/view/screen/account/signup_screen.dart';

class SignINScreen extends StatefulWidget {
  const SignINScreen({super.key});

  @override
  State<SignINScreen> createState() => _SignINScreenState();
}

class _SignINScreenState extends State<SignINScreen> {

  // Todo: Properties
  final TextEditingController _userNameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool isShowPass = true;

  String getSubString(String number) {
    if (number[0] == '0') {
      return number.substring(1, number.length);
    }
    return number;
  }

  // Todo: Body
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (auth) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(body: _buildBody(auth)),
      );
    });
  }

  // Todo: buildBody
  Widget _buildBody(auth) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 126),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextTitle,
                    Container(
                      height: 4,
                      width: 25,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: ColorResources.blueColor)
                    ),
                    SizedBox(height: 56),
                    _buildUserName(auth),
                    SizedBox(height: 16),
                    _buildPassword(auth),
                    SizedBox(height: 8),
                    _buildForgetPassword(auth),
                    SizedBox(height: 64),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          CustomButtonWidget.buildButtonClick(
                            size: 50  ,
                            title: "Sign In".tr,
                            activeColor: true,
                            onPress: (_userNameCtrl.text.length < 3 || _passwordCtrl.text.length < 5) ? null : () {
                              nextScreenNoReturn(Get.context, AppScreen());
                            }
                          ),
                          SizedBox(height: 16),
                          CustomButtonWidget.buildButtonClick(
                            size: 50,
                            title: "Sign Up".tr,
                            activeColor: false,
                            onPress: () {
                              nextScreen(context, SignUPScreen());
                            }
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Todo: buildTextTitle
  Widget get _buildTextTitle {
    return Row(
      children: [
        Text("signIn".tr, style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w500)),
        Spacer()
      ],
    );
  }

  // Todo: buildUserName
  Widget _buildUserName(auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("User Name".tr, style: TextStyle(color: Colors.black, fontSize: 16)),
        SizedBox(height: 8,),
        SizedBox(
          height: 50,
          child: CustomTextFieldWidget(
            hintText: "Enter user name".tr,
            icon: Icons.person,
            _userNameCtrl,
            isPhoneNumber: false,
            label: "Enter user name".tr,
            border: BorderSide(color: Colors.transparent),
            authController: auth,
            onChange: (value) {
              if (_userNameCtrl.text.isNotEmpty) {
                auth.setUserName(true);
              } else {
                auth.setUserName(false);
              }
            },
          ),
        ),
      ],
    );
  }

  // Todo: buildPassword
  Widget _buildPassword(auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("password".tr, style: TextStyle(color: Colors.black, fontSize: 16)),
        SizedBox(height: 8,),
        SizedBox(
          height: 50,
          child: CustomTextFieldWidget(
            hintText: 'password'.tr,
            icon: Icons.lock,
            _passwordCtrl,
            isPhoneNumber: false,
            label: "enterPassword".tr,
            isObscureText: isShowPass,
            isShowSuffix: true,
            border: BorderSide(color: auth.isPassword ? Colors.transparent : Colors.transparent),
            onPress: () {
              setState(() {
                isShowPass = !isShowPass;
              });
            },
            authController: auth,
            onChange: (value) {
              if (_passwordCtrl.text.isNotEmpty) {
                auth.setPassword(true);
              } else {
                auth.setPassword(false);
              }
            },
          ),
        ),
      ],
    );
  }

  // Todo: buildForgetPassword
  Widget _buildForgetPassword(auth) {
    return Row(
      children: [
        Spacer(),
        GestureDetector(
          onTap: () => nextScreen(context, ForgetPasswordScreen()),
          child: Text(
            "${"forgetPassword".tr}?",
            style: TextStyle(color: ColorResources.blueColor, fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
