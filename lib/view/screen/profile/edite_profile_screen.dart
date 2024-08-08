import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../controller/auth_controller.dart';
import '../../../util/color_resources.dart';
import '../../../util/style.dart';

class EditeProfileScreen extends StatefulWidget {
  const EditeProfileScreen({super.key});

  @override
  State<EditeProfileScreen> createState() => _EditeProfileScreenState();
}

class _EditeProfileScreenState extends State<EditeProfileScreen> {
  AuthController authController = Get.find<AuthController>();
  final _form = GlobalKey<FormState>();
  final phoneNumberFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool isAgree = false;
  bool obscureText = true;
  var enterPassword = "";
  var enterPhone = "";
  XFile? _imageDriverID;
  final ImagePicker _picker = ImagePicker();

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
  XFile? _imageProfile;
  Future<void> pickImageProfille(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    setState(() {
      if (selectedImage != null) {
        _imageProfile = selectedImage;
      } else {
        print('No image selected.');
      }
    });
  }
  //Todo: isValidEmail
  bool isValidEmail(String email) {
    final RegExp regex =
    RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }
  // Todo: buildDropdownGender
  final List<String> _gender = ['male', 'female', 'other'];
  String? _selectedGender;
  // Todo: buildPickDate
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
  //Todo: formatDateOfBirth
  String formatDateOfBirth(String? dateOfBirth) {
    if (dateOfBirth == null) return "N/A";
    DateTime dob = DateTime.parse(dateOfBirth);
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dob);
  }
  // Todo: Submit
  // void submit() async {
  //   if (_form.currentState!.validate()) {
  //     authController.editePassengerController(
  //       context,
  //       firstName: _firstNameController.text,
  //       lastName: _lastNameController.text,
  //       phoneNumber: _phoneController.text,
  //       gender: _selectedGender!,
  //       dateOfBirth: _dateController.text,
  //       email: _emailController.text,
  //       oldPassword: _oldPasswordController.text,
  //       newPassword: _newPasswordController.text,
  //     );
  //     print("fist Name : $_firstNameController");
  //   }else{
  //     print("error");
  //   }
  // }

  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      init();
    });
    super.initState();
  }

  Future<void> init() async {
    await authController.getDriverProfileController();
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: ColorResources.primaryColor,
        title: Text('ត្រឡប់ក្រោយ', style: TextStyle(color: ColorResources.whiteColor, fontSize: 14)),
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.angleLeft, color: ColorResources.whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildBody(authController),
    );
  }
  //Todo: buildBody
  Widget _buildBody(AuthController authController) {
    var passengerInfo = authController.userDriverMap?['userDetails'];
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
                      height: 150,
                      width: Get.width * 0.5,
                      color: Colors.transparent,
                      child: Image.asset('assets/images/logo.jpg', fit: BoxFit.cover,),
                    ),
                    SizedBox(height: 16),
                    _buildTextField(passengerInfo?["first_name"] ?? "N/A","នាមខ្លួន", _firstNameController, TextInputType.text, TextInputAction.next, phoneNumberFocusNode, "Please enter your first name"),

                    SizedBox(height: 16),
                    _buildTextField(passengerInfo?["last_name"] ?? "N/A","គោត្តនាម", _lastNameController, TextInputType.text, TextInputAction.next, phoneNumberFocusNode, "Please enter your last name"),
                    SizedBox(height: 16),
                    _buildTextField(passengerInfo?["phone_number"] ?? "N/A" ,"លេខទូរសព្ទ", _phoneController, TextInputType.phone, TextInputAction.next, phoneNumberFocusNode, "phone number must be 9 characters or longer", minLength: 9),
                    SizedBox(height: 16),
                    _buildDropdown("ភេទ", _gender, _selectedGender, (value) => _selectedGender = value, "Please select your gender"),
                    SizedBox(height: 16),
                    _buildDatePicker(formatDateOfBirth(passengerInfo?["date_of_birth"]),"ថ្ងៃខែឆ្នាំកំណើត", _dateController, _pickDate, "Please pick your date of birth"),
                    SizedBox(height: 16),
                    _buildTextField(authController.userDriverMap?['email'] ?? "N/A","អ៊ីម៉ែល", _emailController, TextInputType.emailAddress, TextInputAction.next, phoneNumberFocusNode, "Please enter valid email", validator: isValidEmail),
                    SizedBox(height: 16),
                    _buildTextField("លេខសម្ងាត់ចាស់", "លេខសម្ងាត់ចាស់", _oldPasswordController, TextInputType.text, TextInputAction.next, passwordFocusNode, "Please enter your old password", minLength: 6),
                    SizedBox(height: 16),
                    _buildTextField("លេខសម្ងាត់ថ្មី", "លេខសម្ងាត់ថ្មី", _newPasswordController, TextInputType.text, TextInputAction.done, passwordFocusNode, "Please enter your new password", minLength: 6),
                    SizedBox(height: 16),
                    _buildImagePicker("អត្តសញ្ញាណប័ណ្ណ", _imageDriverID, pickImageID),
                    SizedBox(height: 16),
                    _buildImagePicker("ប័ណ្ណបេីកបរ", _imageDriverLicense, pickImageDriverLicense),
                    SizedBox(height: 16),
                    _buildImagePicker("កែប្រែរូបតំណាង", _imageProfile, pickImageProfille),
                    /*  Row(
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
                    ),*/
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: (){},
                        child: Text(
                          'រក្សាទុក',
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
                  ],
                ),

              ),
            ),
          ),
        ),
      ),
    );
  }
  //Todo: buildTextField
  Widget _buildTextField( label, String labelTitle, TextEditingController controller, TextInputType type, TextInputAction action, FocusNode focusNode, String errorMsg, {int? minLength, Function? validator}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelTitle, style: textStyleMedium),
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
              hintText: label,
              suffixIcon: IconButton(
                onPressed: (){
                  controller.clear();
                },
                icon: Icon(Icons.clear),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
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
  //Todo: buildDatePicker
  Widget _buildDatePicker(String label,String labelTitle, TextEditingController controller, Function onTap, String errorMsg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelTitle, style: textStyleMedium),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.datetime,

          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),

            ),

            hintText: label,
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => onTap(),
            ),
          ),
          readOnly: true,
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return errorMsg;
          //   }
          //   return null;
          // },
        ),
      ],
    );
  }
  //Todo: buildDropdownGender
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
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return errorMsg;
          //   }
          //   return null;
          // },
        ),
      ],
    );
  }
  //Todo: buildImagePicker
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
}
