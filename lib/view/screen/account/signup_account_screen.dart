// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/app/app_screen.dart';
import 'package:scholarar/view/screen/home/home_screen.dart';
import 'package:scholarar/view/screen/splash/splash_screen.dart';

class SignUpAccountScreen extends StatefulWidget {
  const SignUpAccountScreen({super.key});

  @override
  State<SignUpAccountScreen> createState() => _SignUpAccountScreenState();
}

class _SignUpAccountScreenState extends State<SignUpAccountScreen> {
  final phoneNumberForcusNode = FocusNode();
  final passwordForcusNode = FocusNode();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool obscureText = true;
  final _form = GlobalKey<FormState>();
  var enterPassword = "";
  var enterPhone = "";
  //Todo: Provinces
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedCommune;
  String? selectedVillage;

  //rep

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
  //Gender
  final List<String> _gender = ['ប្រុស', 'ស្រី'];
  String? _selectedGender;
  //date
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

  //Submit
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
    return GetBuilder<AuthController>(builder: (auth) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(body: _buildBody()),
      );
    });
  }

  //Todo: buildBody
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
                    //Todo: firsname
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
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) =>
                                phoneNumberForcusNode.requestFocus(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              //labelText: 'First name',
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
                            onSaved: (newValue) => enterPhone = newValue!,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    //Todo: Lastname
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
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) =>
                                phoneNumberForcusNode.requestFocus(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              // labelText: 'Last name',
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
                            onSaved: (newValue) => enterPhone = newValue!,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    //Todo: Phone number
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
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) =>
                                phoneNumberForcusNode.requestFocus(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              //labelText: 'Phone Number',
                              hintText: 'បញ្ចូលលេខទូរសព្ទរបស់អ្នក',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().length < 9) {
                                return 'phone number muse be 9 character or long';
                              }
                              return null;
                            },
                            onSaved: (newValue) => enterPhone = newValue!,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    //Todo: gender
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ភេទ",
                          style: TextStyle(color: ColorResources.blackColor),
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.wc),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: 'ជ្រើសរើសភេទ'),
                          items: _gender.map((String gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your degree';
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
                            // labelText: 'Date of Birth',
                            hintText: "ជ្រើសរើសថ្ងៃខែឆ្នាំកំណើត",
                           // prefixIcon: Icon(Icons.l),
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
                        SizedBox(height: 16),
                        //Todo: password
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ពាក្យសម្ងាត់",
                              style:
                                  TextStyle(color: ColorResources.blackColor),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 60,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) =>
                                    phoneNumberForcusNode.requestFocus(),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  //labelText: 'Phone Number',
                                  hintText: 'បញ្ចូលពាក្យសម្ងាត់',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 9) {
                                    return 'ពាក្យសម្ងាត់ត្រូវមានច្រើនជាង 9 តួអក្សរ';
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
                              "ពាក្យសម្ងាត់ម្តងទៀត",
                              style:
                                  TextStyle(color: ColorResources.blackColor),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 60,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) =>
                                    phoneNumberForcusNode.requestFocus(),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  //labelText: 'Phone Number',
                                  hintText: 'បញ្ចូលពាក្យសម្ងាត់ម្តងទៀត',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 9) {
                                    return 'ពាក្យសម្ងាត់ត្រូវមានច្រើនជាង 9 តួអក្សរ';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) => enterPhone = newValue!,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //Todo: privine selecte in cambodia
                    SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ភេទ",
                          style: TextStyle(color: ColorResources.blackColor),
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.wc),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: 'ជ្រើសរើសភេទ'),
                          items: _gender.map((String gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your degree';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            nextScreenNoReturn(context, AppScreen());
                            submit();
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
                        )),
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
}
