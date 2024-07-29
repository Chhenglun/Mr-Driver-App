// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/view/custom/custom_button_widget.dart';
import 'package:scholarar/view/custom/custom_textfield_widget.dart';

class SetPasswordScreen extends StatefulWidget {

  bool isFromSignUp;
  SetPasswordScreen({super.key, this.isFromSignUp = true});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {

  // Todo: Properties
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  bool isShowPass = true;
  bool isShowConfirmPass = true;
  bool isLimitCharacter = false;
  bool isValidDigitAndSymbol = false;

  // Function to validate the password
  bool limitCharacter(String password) {
    // big than 5 and small than 20
    if (password.length < 5 || password.length > 20) {
      return false;
    }
    return true;
  }

  bool _validateDigitAndSymbol(String password) {
    // Contains at least one letter and at least one symbol excluding 0-9
    if (!password.contains(RegExp(r'[A-Za-z]')) || !password.contains(RegExp(r'[!$@#%^&*(),.?":{}|<>]'))) {
      return false;
    }
    return true;
  }

  // Todo: Body
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (auth){
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
              SizedBox(height: 66),
              GestureDetector(
                onTap: () => Get.back(),
                child: Row(
                  mainAxisAlignment: widget.isFromSignUp ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                  children: [
                    Image(image: AssetImage("assets/icons/arrow_left.png"), width: 28, height: 28, color: Colors.black),
                    Text(widget.isFromSignUp ? "" : "forgetPassword".tr, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
                    Icon(Icons.close, color: Colors.transparent, size: 28),
                  ],
                )
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
                    _buildTextTitle,
                    Container(
                      height: 4,
                      width: 25,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: ColorResources.blueColor)
                    ),
                    SizedBox(height: 56),
                    _buildPassword(auth),
                    SizedBox(height: 16),
                    _buildConfirmPassword(auth),
                    SizedBox(height: 24),
                    _buildDescriptionPassword(auth),
                    SizedBox(height: 80),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: CustomButtonWidget.buildButtonClick(
                        size: 50,
                        title: "done".tr,
                        activeColor: true,
                        onPress: ((_passwordCtrl.text != _confirmPasswordCtrl.text) || _passwordCtrl.text.length < 5 || !isValidDigitAndSymbol) ? null : () {

                        }
                      ),
                    )
                  ],
                ),
              ),
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
        Text(
          widget.isFromSignUp ? "setPassword".tr : "Enter New Password",
          style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w500),
        ),
        Spacer()
      ],
    );
  }

  // Todo: buildPassword
  Widget _buildPassword(auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.isFromSignUp ? "password".tr : "New Password", style: TextStyle(color: Colors.black, fontSize: 16)),
        SizedBox(height: 8,),
        SizedBox(
          height: 50,
          child: CustomTextFieldWidget(
            hintText: "Enter new password".tr,
            icon: Icons.lock,
            _passwordCtrl,
            isPhoneNumber: false,
            label: "enterPassword".tr,
            isObscureText: isShowPass,
            isShowSuffix: true,
            border: BorderSide(color: Colors.transparent),
            onPress: () {
              setState(() {
                isShowPass = !isShowPass;
              });
            },
            authController: auth,
            onChange: (value) {
              if (_passwordCtrl.text.length > 5 || _passwordCtrl.text.length < 20) {
                isLimitCharacter = limitCharacter(_passwordCtrl.text);
                isValidDigitAndSymbol = _validateDigitAndSymbol(_passwordCtrl.text);
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

  // Todo: buildConfirmPassword
  Widget _buildConfirmPassword(auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("confirmPassword".tr, style: TextStyle(color: Colors.black, fontSize: 16)),
        SizedBox(height: 8,),
        SizedBox(
          height: 50,
          child: CustomTextFieldWidget(
            hintText: 'confirmPassword'.tr,
            icon: Icons.lock,
            _confirmPasswordCtrl,
            isPhoneNumber: false,
            label: "enterPassword".tr,
            isObscureText: isShowConfirmPass,
            isShowSuffix: true,
            border: BorderSide(color: auth.isConfirmPassword ? Colors.transparent : Colors.transparent),
            onPress: () {
              setState(() {
                isShowConfirmPass = !isShowConfirmPass;
              });
            },
            authController: auth,
            onChange: (value) {
              if (_confirmPasswordCtrl.text.isNotEmpty) {
                auth.setConfirmPassword(true);
              } else {
                auth.setConfirmPassword(false);
              }
            },
          ),
        ),
      ],
    );
  }

  // Todo: buildDescriptionPassword
  Widget _buildDescriptionPassword(auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.check, color: isLimitCharacter ? ColorResources.blueColor : Colors.grey, size: 16),
            Text(
              " Contains 5 to 20 characters",
              style: TextStyle(color: isLimitCharacter ? ColorResources.blueColor : Colors.grey, fontSize: 14),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(height: 2),
                Icon(Icons.check, color: isValidDigitAndSymbol ? ColorResources.blueColor : Colors.grey, size: 16),
              ],
            ),
            SizedBox(width: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Text(
                "Contains at least two types of digits, letters and symbols",
                style: TextStyle(color: isValidDigitAndSymbol ? ColorResources.blueColor : Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.check, color: ((_passwordCtrl.text != _confirmPasswordCtrl.text) || _passwordCtrl.text.length < 5) ? Colors.grey : ColorResources.blueColor, size: 16),
            Text(
              " The password entered twice is the same",
              style: TextStyle(color: ((_passwordCtrl.text != _confirmPasswordCtrl.text) || _passwordCtrl.text.length < 5) ? Colors.grey : ColorResources.blueColor, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
