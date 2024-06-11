// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/util/style.dart';
import 'package:scholarar/view/app/app_screen.dart';

class SignUpAccountScreen extends StatefulWidget {
  const SignUpAccountScreen({super.key});

  @override
  State<SignUpAccountScreen> createState() => _SignUpAccountScreenState();
}

class _SignUpAccountScreenState extends State<SignUpAccountScreen> {
  AuthController authController = Get.find<AuthController>();
  final phoneNumberFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool isAgree = false;
  bool obscureText = true;
  final _form = GlobalKey<FormState>();
  var enterPassword = "";
  var enterPhone = "";
  //validate email
  bool isValidEmail(String email) {
    final RegExp regex =
    RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }

  // Provinces
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedCommune;
  String? selectedVillage;

  final List<String> _province = [
    'បន្ទាយមានជ័យ',
    'បាត់ដំបង',
    'កំពង់ចាម',
    'កំពង់ឆ្នាំង',
    'កំពង់ស្ពឺ',
    'កំពង់ធំ',
    'កំពត',
    'កណ្តាល',
    'កែប',
    'កោះកុង',
    'ក្រចេះ',
    'មណ្ឌលគិរី',
    'ឧត្តរមានជ័យ',
    'បៃលិន',
    'ភ្នំពេញ',
    'ព្រះសីហនុ',
    'ព្រះវិហារ',
    'ពោធិ៍សាត់',
    'រតនគិរី',
    'សៀមរាប',
    'ស្ទឹងត្រែង',
    'ស្វាយរៀង',
    'តាកែវ',
    'ត្បូងឃ្មុំ',
  ];

  // Gender
  final List<String> _gender = ['male', 'female', 'other'];
  String? _selectedGender;

  // Date
  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  // Submit
  void submit() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (isAgree == true) {
      _form.currentState!.validate();
      authController.registerDriverController(
        context,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneController.text,
        email: _emailController.text,
        password: _passwordController.text,
        gender: _selectedGender!,
        dateOfBirth: _dateController.text,
      );
      //nextScreen(context, AppScreen());
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
          style: textStyleLowMedium.copyWith(
            color: ColorResources.redColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (auth) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(body: _buildBody()),
      );
    });
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      color: Colors.transparent,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: ColorResources.backgroundBannerColor,
                        backgroundImage: AssetImage('assets/images/logo.jpg'),
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "នាមខ្លួន",
                          style: TextStyle(color: ColorResources.blackColor),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: _firstNameController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) => phoneNumberFocusNode.requestFocus(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'បញ្ចូលនាមខ្លួនរបស់អ្នក',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "គោត្តនាម",
                          style: TextStyle(color: ColorResources.blackColor),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 60,
                          child: TextFormField(

                            controller: _lastNameController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) =>
                                phoneNumberFocusNode.requestFocus(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'បញ្ចូលគោត្តនាមរបស់អ្នក',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "លេខទូរសព្ទ",
                          style: TextStyle(color: ColorResources.blackColor),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) =>
                                phoneNumberFocusNode.requestFocus(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              hintText: 'បញ្ចូលលេខទូរសព្ទរបស់អ្នក',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().length < 9) {
                                return 'phone number must be 9 characters or longer';
                              }
                              return null;
                            },
                            onSaved: (newValue) => enterPhone = newValue!,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ភេទ",
                          style: TextStyle(color: Colors.black),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.wc),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'ជ្រើសរើសភេទ',
                          ),
                          items: _gender.map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your gender';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ថ្ងៃខែឆ្នាំកំណើត",
                          style: TextStyle(color: ColorResources.blackColor),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _dateController,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: "ជ្រើសរើសថ្ងៃខែឆ្នាំកំណើត",
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: _pickDate,
                            ),
                          ),
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please pick your date of birth';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "អ៊ីម៉ែល",
                          style: TextStyle(color: ColorResources.blackColor),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) =>
                                phoneNumberFocusNode.requestFocus(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'បញ្ចូលអ៊ីម៉ែលរបស់អ្នក',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your email";
                              } else if (!GetUtils.isEmail(value)) {
                                return "Please enter valid email";
                              }
                              return null;
                            },
                            onSaved: (newValue) => enterPhone = newValue!,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ពាក្យសម្ងាត់",
                          style: TextStyle(color: ColorResources.blackColor),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: obscureText,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) =>
                                phoneNumberFocusNode.requestFocus(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'បញ្ចូលពាក្យសម្ងាត់',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().length < 9) {
                                return 'ពាក្យសម្ងាត់ត្រូវមានច្រើនជាង 9 តួអក្សរ';
                              }
                              return null;
                            },
                            onSaved: (newValue) => enterPassword = newValue!,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: isAgree,
                          onChanged: (value) {
                            setState(() {
                              isAgree = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            'ខ្ញុំបាទបានអាននិងយល់ព្រមលើលក្ខខណ្ឌនិងលក្ខខណ្ឌសម្រាប់ប្រព័ន្ធរបស់ខ្ញុំ',
                            style: TextStyle(
                              color: ColorResources.blackColor,
                              height: 1.5,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // isAgree == false ? SizedBox(
                    //   height: 50,
                    //   width: double.infinity,
                    //   child: TextButton(
                    //     onPressed: () {
                    //       //submit();
                    //     },
                    //     child: Text(
                    //       'ចុះឈ្មោះ',
                    //       style: TextStyle(color: Colors.white, fontSize: 20),
                    //     ),
                    //     style: TextButton.styleFrom(
                    //       backgroundColor: ColorResources.greyColor,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //     ),
                    //   ),
                    // ) :
                      SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          if (isAgree == true) {
                            _form.currentState!.validate();
                            authController.registerDriverController(
                              context,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              phoneNumber: _phoneController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              gender: _selectedGender!,
                              dateOfBirth: _dateController.text,
                            );
                            //nextScreen(context, AppScreen());
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
                                style: textStyleLowMedium.copyWith(
                                  color: ColorResources.redColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            );
                          }
                        },
                        child: Text(
                          'ចូលគណនី',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: ColorResources.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FocusNode>(
        'passwordFocusNode', passwordFocusNode));
  }
}
