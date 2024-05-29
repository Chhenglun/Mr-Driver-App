// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/style.dart';
import 'package:scholarar/view/custom/custom_button_widget.dart';
import 'package:scholarar/view/custom/custom_listtile_setting_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _userNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  final TextEditingController _phoneNumberCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String gender = 'male';

  File? _fileImage;
  bool isMale = false;
  bool isFemale = false;
  bool isAgree = false;
  bool isFloating = true;
  bool isSnap = true;
  bool isPinned = false;

  //Todo : Validate Email Address
  bool isValidEmail(String email) {
    final RegExp regex =
        RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }

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

  Widget _buildBody(auth) {
    return Container(
      color: ColorResources.primaryColor,
      width: Get.width,
      height: Get.height,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              centerTitle: true,
              backgroundColor: ColorResources.primaryColor,
              elevation: 0,
              leading: Container(),
              titleSpacing: 0,
              title: Text(
                "Register",
                style: robotoBold.copyWith(color: Colors.white, fontSize: 20),
              ),
              snap: isSnap,
              floating: isFloating,
              pinned: isPinned,
              // Add any additional properties you need
            ),
            SliverToBoxAdapter(
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  color: ColorResources.primaryColor,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 16,
                        child: Container(
                          height: Get.height,
                          width: Get.width,
                          color: ColorResources.primaryColor,
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: Image.asset('assets/images/logo.jpg').image,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 140,
                        child: Form(
                          key: _formKey,
                          child: Container(
                            width: Get.width,
                            height: Get.height * 0.85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32),
                              ),
                              color: ColorResources.whiteColor,
                            ),
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(vertical: 32,horizontal: 16),
                              physics: BouncingScrollPhysics(),
                              child: Wrap(
                                children: [
                                  //Todo: profileImage
                                  /*profile(
                                          _fileImage,
                                          100,
                                          name: "User name",
                                          icon: Icons.camera_alt,
                                          onPress: () {
                                            //pickImage();
                                          },
                                        ),*/
                                  SizedBox(height: 16,width: 1,),
                                  //Todo: username
                                  CustomListWidget.customTextformfield(
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                    labelText: "Username",
                                    icon: Icons.person,
                                    onChanged: (value) {
                                      print(value);
                                    },
                                    keyboardType: TextInputType.text,
                                    obscureText: false,
                                    textInputAction: TextInputAction.next,
                                    controller: _userNameCtrl,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter your username";
                                      } else if (value.length < 3) {
                                        return "Username must be at least 3 characters";
                                      }
                                      return null;
                                    },
                                  ),
                                  //Todo: check male & female
                                  _buildSex(),
                                  //Todo: phoneNumber
                                  // CustomListWidget.customTextformfield(
                                  //   style: TextStyle(
                                  //     color: Colors.grey,
                                  //     fontSize: 16,
                                  //   ),
                                  //   labelText: "Phone Number",
                                  //   icon: Icons.phone,
                                  //   onChanged: (value) {},
                                  //   keyboardType: TextInputType.phone,
                                  //   obscureText: false,
                                  //   textInputAction: TextInputAction.next,
                                  //   controller: _phoneNumberCtrl,
                                  //   validator: (value) {
                                  //     if (value.isEmpty) {
                                  //       return "Please enter your phone number";
                                  //     }
                                  //     if(!GetUtils.isPhoneNumber(value)){
                                  //       return "Is Not P";
                                  //     }
                                  //     return null;
                                  //   },
                                  // ),
                                  SizedBox(height: 8.0,width: 1,),
                                  //Todo: Email
                                  CustomListWidget.customTextformfield(
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                    labelText: "Email Adress",
                                    icon: Icons.email,
                                    onChanged: (value) {},
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: false,
                                    textInputAction: TextInputAction.next,
                                    controller: _emailCtrl,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter your email";
                                      } else if (!GetUtils.isEmail(value)) {
                                        return "Please enter valid email";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16,width: 1,),
                                  //Todo: password
                                  CustomListWidget.customTextformfield(
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                    labelText: "Password",
                                    icon: Icons.lock,
                                    onChanged: (value) {},
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: false,
                                    textInputAction: TextInputAction.next,
                                    controller: _passwordCtrl,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter your password";
                                      } else if (value.length < 6) {
                                        return "Password must be at least 6 characters";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16,width: 1,),
                                  //Todo: confirmPassword
                                  CustomListWidget.customTextformfield(
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                    labelText: "Re-Password",
                                    icon: Icons.lock,
                                    onChanged: (value) {},
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: false,
                                    textInputAction: TextInputAction.next,
                                    controller: _confirmPasswordCtrl,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your password";
                                      } else if (value.length < 6) {
                                        return "Password must be at least 6 characters";
                                      }
                                      return null;
                                    },
                                  ),
                                  //Todo: check agree & condition
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isAgree,
                                        onChanged: (value) {
                                          setState(() {
                                            isAgree = value ?? false;
                                          });
                                          if(isAgree) {
                                            Get.bottomSheet(
                                              _buildTermsAndConditions(),
                                              isScrollControlled: true,
                                            );
                                          }
                                        },
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.bottomSheet(
                                            _buildTermsAndConditions(),
                                            isScrollControlled: true,
                                          );
                                        },
                                        child: Text(
                                          "I agree to the terms and conditions",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 48,width: 1,),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(32),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: CustomButtonWidget.buildButtonClick(
                                      size: 50,
                                      title: "Register",
                                      activeColor: isAgree,
                                      onPress: () {
                                        if (isAgree) {
                                          if(_formKey.currentState!.validate()){
                                            authController.registerController(
                                              context,
                                              name: _userNameCtrl.text,
                                              gender: gender,
                                              // phoneNumber: ,
                                              email: _emailCtrl.text,
                                              password: _passwordCtrl.text,
                                              confirmPassword:
                                              _confirmPasswordCtrl.text,
                                            );
                                          }
                                        } else {
                                          Get.snackbar(
                                            "Error!",
                                            "",
                                            snackPosition: SnackPosition.TOP,
                                            backgroundColor: ColorResources.whiteColor,
                                            snackStyle: SnackStyle.FLOATING,
                                            colorText: ColorResources.primaryColor,
                                            messageText: Text(
                                              "Please agree to the terms and conditions",
                                              style: textStyleLowMedium.copyWith(color: ColorResources.redColor,fontWeight: FontWeight.bold),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16,width: 1,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Already have an account?"),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("Login"),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 82,width: 1,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildSex() {
    return FormField(
      builder: (state) => Row(
        children: [
          Row(
            children: [
              Radio(
                value: 'male',
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value as String;
                    print(gender);
                  });
                },
              ),
              const SizedBox(width: 4),
              Text('Male')
            ],
          ),
          Row(
            children: [
              Radio(
                value: 'female',
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value as String;
                    print(gender);
                  });
                },
              ),
              const SizedBox(width: 4),
              Text('Female')
            ],
          ),
          // SizedBox(width: 15),
          // Row(
          //   children: [
          //     Checkbox(
          //       value: isFemale,
          //       onChanged: (value) {
          //         setState(() {
          //           isFemale = value ?? false;
          //           if (isFemale) {
          //             isMale = false; // Unselect male if female is selected
          //           }
          //         });
          //       },
          //     ),
          //     Text('Female'),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
      height: Get.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            "Terms and Conditions",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "1. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nunc nec ultricies ultricies, nunc.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "2. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nunc nec ultricies ultricies, nunc.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "3. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nunc nec ultricies ultricies, nunc.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "4. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nunc nec ultricies ultricies, nunc.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "5. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nunc nec ultricies ultricies, nunc.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "6. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nunc nec ultricies ultricies, nunc.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "7. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nunc nec ultricies ultricies, nunc.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "8. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nunc nec ultricies ultricies, nunc.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
//Todo: pickImage
/*'Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final File file = File(image.path);
    _fileImage = file;
    setState(() {});
  }*/
}
