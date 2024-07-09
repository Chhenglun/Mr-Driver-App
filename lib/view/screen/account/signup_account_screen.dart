// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last

import 'dart:convert';
import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/style.dart';

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

  //upload image and camera
  final ImagePicker _picker = ImagePicker();
  XFile? _imageDriverID;
  Future<void> pickImageID(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    setState(() {
      if (selectedImage != null) {
        _imageDriverID = selectedImage;
      } else {
        print('No image selected.');
      }
    });
  }

  XFile? _imageDriverLicense;
  Future<void> pickImageDriverLicense(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    setState(() {
      if (selectedImage != null) {
        _imageDriverLicense = selectedImage;
      } else {
        print('No image selected.');
      }
    });
  }
  // Submit
  void submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (isAgree) {
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
        iDCard: _imageDriverID!,
        drivingLicense: _imageDriverLicense!,
      );
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
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
                    _buildTextField("នាមខ្លួន", _firstNameController, TextInputType.text, TextInputAction.next, phoneNumberFocusNode, "Please enter your first name"),
                    SizedBox(height: 16),
                    _buildTextField("គោត្តនាម", _lastNameController, TextInputType.text, TextInputAction.next, phoneNumberFocusNode, "Please enter your last name"),
                    SizedBox(height: 16),
                    _buildTextField("លេខទូរសព្ទ", _phoneController, TextInputType.phone, TextInputAction.next, phoneNumberFocusNode, "phone number must be 9 characters or longer", minLength: 9),
                    SizedBox(height: 16),
                    _buildDropdown("ភេទ", _gender, _selectedGender, (value) => _selectedGender = value, "Please select your gender"),
                    SizedBox(height: 16),
                    _buildDatePicker("ថ្ងៃខែឆ្នាំកំណើត", _dateController, _pickDate, "Please pick your date of birth"),
                    SizedBox(height: 16),
                    _buildTextField("អ៊ីម៉ែល", _emailController, TextInputType.emailAddress, TextInputAction.next, phoneNumberFocusNode, "Please enter valid email", validator: isValidEmail),
                    SizedBox(height: 16),
                    _buildPasswordField("ពាក្យសម្ងាត់", _passwordController, obscureText, () => setState(() => obscureText = !obscureText), "ពាក្យសម្ងាត់ត្រូវមានច្រើនជាង 9 តួអក្សរ"),
                    SizedBox(height: 16),
                    _buildImagePicker("អត្តសញ្ញាញប័ណ្ឌ", _imageDriverID, pickImageID),
                    SizedBox(height: 16),
                    _buildImagePicker("ប័ណ្ឌបើកបរ", _imageDriverLicense, pickImageDriverLicense),
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
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: submit,
                        child: Text(
                          'បង្កើតគណនី',
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

  Widget _buildTextField(String label, TextEditingController controller, TextInputType type, TextInputAction action, FocusNode focusNode, String errorMsg, {int? minLength, Function? validator}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textStyleMedium),
        SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: controller,
            keyboardType: type,
            textInputAction: action,
            onFieldSubmitted: (value) => focusNode.requestFocus(),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              hintText: 'បញ្ចូល${label}របស់អ្នក',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || (minLength != null && value.trim().length < minLength)) {
                return errorMsg;
              }
              if (validator != null && !validator(value)) {
                return errorMsg;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedItem, Function(String?) onChanged, String errorMsg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textStyleMedium),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.wc),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: 'ជ្រើសរើស${label}',
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorMsg;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, TextEditingController controller, Function onTap, String errorMsg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textStyleMedium),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: "ជ្រើសរើស${label}",
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => onTap(),
            ),
          ),
          readOnly: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorMsg;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscure, Function onTap, String errorMsg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textStyleMedium),
        SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) => phoneNumberFocusNode.requestFocus(),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              hintText: 'បញ្ចូល${label}',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => onTap(),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().length < 9) {
                return errorMsg;
              }
              return null;
            },
            onSaved: (newValue) => enterPassword = newValue!,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker(String label, XFile? image, Function onTap) {
    return image == null
        ? InkWell(
      onTap: () => onTap(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textStyleMedium),
          SizedBox(height: 8),
          Container(
            width: Get.width,
            height: 200,
            decoration: BoxDecoration(
              color: ColorResources.backgroundBannerColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => onTap(ImageSource.gallery),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo),
                        SizedBox(height: 8),
                        Text('ជ្រើសរើសរូបភាព'),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(height: 1, color: ColorResources.greyColor),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () => onTap(ImageSource.camera),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt),
                        SizedBox(height: 8),
                        Text('បើកកាមេរ៉ា'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        : Container(
      width: Get.width,
      height: 200,
      decoration: BoxDecoration(
        color: ColorResources.backgroundBannerColor,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: FileImage(File(image.path)),
          fit: BoxFit.cover,
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
