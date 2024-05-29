// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/custom/custom_button_widget.dart';
import 'package:scholarar/view/custom/custom_textfield_widget.dart';
import 'package:scholarar/view/screen/account/set_password_screen.dart';

class SignUPScreen extends StatefulWidget {

  const SignUPScreen({super.key});

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {

  // Todo: Properties
  final TextEditingController _userNameCtrl = TextEditingController();
  bool isCheck = false;

  // Todo: Body
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (auth){
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: _buildBody(auth)
        ),
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
                child: Image(image: AssetImage("assets/icons/arrow_left.png"), width: 28, height: 28, color: Colors.black)
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
                    _buildUserName(auth),
                    SizedBox(height: 8),
                    _buildCheckCircle,
                    SizedBox(height: 64),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: CustomButtonWidget.buildButtonClick(
                        size: 50,
                        title: "next".tr,
                        activeColor: true,
                        onPress: (_userNameCtrl.text.length < 3 || isCheck == false) ? null : () {
                          nextScreen(context, SetPasswordScreen());
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
          "signUp".tr,
          style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w500),
        ),
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

  // Todo: buildCheckCircle
  Widget get _buildCheckCircle {
    return GestureDetector(
      onTap: (){
        setState(() {
          isCheck = !isCheck;
        });
      },
      child: Row(
        children: [
          isCheck ? Image.asset("assets/icons/check_circle.png", height: 24, width: 24,) :
          Image.asset("assets/icons/circle.png", height: 24, width: 24),
          SizedBox(width: 8),
          Text("agreeToTheUserAgreement".tr, style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
