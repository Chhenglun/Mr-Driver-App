// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:capstone_project2/controller/auth_controller.dart';
import 'package:capstone_project2/util/next_screen.dart';
import 'package:capstone_project2/view/screen/account/signup_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/color_resources.dart';
import '../../custom/custom_show_snakbar.dart';

class SignInAccountScreen extends StatefulWidget {
  const SignInAccountScreen({super.key});

  @override
  State<SignInAccountScreen> createState() => _SignInAccountScreenState();
}

class _SignInAccountScreenState extends State<SignInAccountScreen> {
  AuthController authController = Get.find<AuthController>();
  final phoneNumberForcusNode = FocusNode();
  final passwordForcusNode = FocusNode();
  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var obscureText = true.obs;
  final _form = GlobalKey<FormState>();
  var enterPassword = "";
  var enterPhone = "";

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }
  /*bool isValidEmail(String email) {
    final RegExp regex = RegExp(
        r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'
    );
    return regex.hasMatch(email);
  }*/

  bool isValidEmail(String email) {
    final RegExp regex =
    RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }

  Future<void> submit1() async {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      authController.loginWithDriver(
        context,
        email: isValidEmail(_emailPhoneController.text)
            ? _emailPhoneController.text
            : '',
        phoneNumber: isValidEmail(_emailPhoneController.text)
            ? ''
            : _emailPhoneController.text,
        password: _passwordController.text,
      );
    }else{
      Navigator.pop(Get.context!);
      customShowSnackBar('Invalid Email Phone or Password!'.tr, Get.context!, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.secondaryColor,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: Get.width * 0.5,
                          color: Colors.transparent,
                          child: Image.asset('assets/images/logo.jpg', fit: BoxFit.cover,),
                        ),
                        SizedBox(height: 20),
                        //Todo : _buildPhone
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "អ៊ីម៉ែល ឬ លេខទូរស័ព្ទ",
                              style: TextStyle(color: ColorResources.blackColor),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 60,
                              child: TextFormField(
                                controller:_emailPhoneController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) => phoneNumberForcusNode.requestFocus(),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  // labelText: 'Phone Number',
                                  hintText: 'Enter your Email or Phone number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 8) {
                                    return 'phone number or email is Invalid';
                                  }
                                  return null;
                                },
                                // onSaved: (newValue) =>  = newValue!,
                              ),
                            ),
                          ],
                        ),
                        //Todo : _buildPassword
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "លេខសម្ងាត់",
                              style:
                                  TextStyle(color: ColorResources.blackColor),
                            ),
                            SizedBox(height: 8),
                            Obx(
                              () => SizedBox(
                                height: 60,
                                child: TextFormField(
                                  focusNode: passwordForcusNode,
                                  cursorColor: Colors.blueGrey,
                                  controller: _passwordController,
                                  obscureText: obscureText.value,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    // labelText: 'Password',
                                    labelStyle:
                                        TextStyle(color: Colors.blueGrey),
                                    hintText: 'Enter your password',

                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    suffixIcon: IconButton(
                                      onPressed: togglePasswordVisibility,
                                      icon: Icon(
                                        obscureText.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().length < 6) {
                                      return 'password muse be 6 character or long';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    enterPassword = value!;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "ភ្លេចពាក្យសម្ងាត់",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: TextButton(
                              onPressed: submit1,
                              /*onPressed: () async{
                                if(_form.currentState!.validate()){
                                  if(_emailPhoneController.value.text.isNotEmpty && _passwordController.value.text.isNotEmpty){
                                    await authController.loginWithEmailNew(context, email:_emailPhoneController.value.text, password:_passwordController.value.text);
                                }else{
                                  Get.snackbar('Error', 'Please enter valid email and password');
                                }
                                // nextScreenNoReturn(context, AppScreen());
                                // submit();
                              }},*/
                              child: Text(
                                'ចូលគណនី',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20,),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: ColorResources.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('មិនទាន់មានគណនី?'),
                            TextButton(
                              onPressed: () {
                                nextScreen(context, SignUpAccountScreen());
                              },
                              child: Text('ចុះឈ្មោះគណនី'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
