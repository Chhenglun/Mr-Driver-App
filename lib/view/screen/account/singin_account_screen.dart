// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/app/app_screen.dart';
import 'package:scholarar/view/screen/account/signup_account_screen.dart';

class SigninAccountScreen extends StatefulWidget {
  const SigninAccountScreen({super.key});

  @override
  State<SigninAccountScreen> createState() => _SigninAccountScreenState();
}

class _SigninAccountScreenState extends State<SigninAccountScreen> {
  AuthController authController = Get.find<AuthController>();
  final phoneNumberForcusNode = FocusNode();
  final passwordForcusNode = FocusNode();
  final _emailControlle = TextEditingController().obs;
  final _passwordController = TextEditingController().obs;
  var obscureText = true.obs;
  final _form = GlobalKey<FormState>();
  var enterPassword = "";
  var enterPhone = "";

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }
  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
        r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'
    );
    return regex.hasMatch(email);
  }

  Future<void> submit() async {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      print(enterPhone);
      print(enterPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteBackgroundColor,
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
                          height: 100,
                          color: Colors.transparent,
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor:
                                ColorResources.backgroundBannerColor,
                            backgroundImage:
                                AssetImage('assets/images/logo.jpg'),
                          ),
                        ),
                        SizedBox(height: 20),
                        //Todo : _buildPhone
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "អ៊ីម៉ែល",
                              style:
                                  TextStyle(color: ColorResources.blackColor),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 60,
                              child: TextFormField(
                                controller: _emailControlle.value,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) =>
                                    phoneNumberForcusNode.requestFocus(),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  // labelText: 'Phone Number',
                                  hintText: 'Enter your Email ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 9) {
                                    return 'phone number muse be 9 character or long';
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
                                  controller: _passwordController.value,
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
                              onPressed: () async{
                                if(_form.currentState!.validate()){
                                  if(_emailControlle.value.text.isNotEmpty && _passwordController.value.text.isNotEmpty){
                                    await authController.loginWithEmailNew(context, email:_emailControlle.value.text, password:_passwordController.value.text);
                                }else{
                                  Get.snackbar('Error', 'Please enter valid email and password');
                                }
                                // nextScreenNoReturn(context, AppScreen());
                                // submit();
                              }},
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
                            Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                nextScreen(context, SignUpAccountScreen());
                              },
                              child: Text('ចុះឈ្ម៖គណនី'),
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
