// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/custom/custom_button_widget.dart';
import 'package:scholarar/view/custom/custom_textfield_widget.dart';
import 'package:scholarar/view/screen/account/set_password_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _documentTypeCtrl = TextEditingController();
  final TextEditingController _documentNumberCtrl = TextEditingController();
  AuthController authController = Get.find<AuthController>();

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
      child: Container(
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 66),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Image(image: AssetImage("assets/icons/arrow_left.png"), width: 28, height: 28, color: Colors.black)
                    ),
                    Text("forgetPassword".tr, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
                    Icon(Icons.close, color: Colors.transparent, size: 28),
                  ],
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
                      _buildFirstName(auth),
                      SizedBox(height: 16),
                      _buildLastName(auth),
                      SizedBox(height: 16),
                      _buildDocumentNumber(auth),
                      SizedBox(height: 80),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: CustomButtonWidget.buildButtonClick(
                          size: 50,
                          title: "done".tr,
                          activeColor: true,
                          onPress: (
                            _firstNameCtrl.text.isEmpty || _lastNameCtrl.text.isEmpty ||
                            _documentTypeCtrl.text.isEmpty || _documentNumberCtrl.text.isEmpty
                          ) ? () {
                            nextScreen(context, SetPasswordScreen(isFromSignUp: false));
                          } : () {
                            nextScreen(context, SetPasswordScreen(isFromSignUp: false));
                          }
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Todo: buildTextTitle
  Widget get _buildTextTitle {
    return Text("verifyIdentity".tr, style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w500));
  }

  // Todo: buildFirstName
  Widget _buildFirstName(auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("firstName".tr, style: TextStyle(color: Colors.black, fontSize: 16)),
        SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: CustomTextFieldWidget(
            hintText: "Enter first name".tr,
            icon: Icons.person,
            _firstNameCtrl,
            isPhoneNumber: false,
            label: "fillFirstName".tr,
            authController: auth,
            onChange: (value){
              if(_firstNameCtrl.text.isNotEmpty){

              }else {

              }
            },
          ),
        )
      ],
    );
  }

  // Todo: buildLastName
  Widget _buildLastName(auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("lastName".tr, style: TextStyle(color: Colors.black, fontSize: 16)),
        SizedBox(height: 8,),
        SizedBox(
          height: 50,
          child: CustomTextFieldWidget(
            hintText: "Enter last name".tr,
            icon: Icons.person,
            _lastNameCtrl,
            isPhoneNumber: false,
            label: "fillLastName".tr,
            authController: auth,
            onChange: (value){
              if(_lastNameCtrl.text.isNotEmpty){

              }else {

              }
            },
          ),
        )
      ],
    );
  }

  // Todo: buildPassportNumber
  Widget _buildDocumentNumber(auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("documentNumber".tr, style: TextStyle(color: Colors.black, fontSize: 16)),
        SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: CustomTextFieldWidget(

            icon: Icons.person,
            hintText: "Enter document number".tr,
            _documentNumberCtrl,
            isPhoneNumber: true,
            label: "Enter document number".tr,
            authController: auth,
            onChange: (value){
              if(_documentNumberCtrl.text.isNotEmpty){

              }else {

              }
            },
          ),
        )
      ],
    );
  }
}
