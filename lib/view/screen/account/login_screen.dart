// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/view/custom/custom_button_widget.dart';
import 'package:scholarar/view/custom/custom_listtile_setting_screen.dart';
import 'package:scholarar/view/screen/account/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{

  //Todo : Properties
  AuthController authController = Get.find<AuthController>();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  File? _fileImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isFloating = true;
  bool isSnap = true;
  bool isPinned = false;
  late TabController _tabController;
  bool isTab = false;
  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
        r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'
    );
    return regex.hasMatch(email);
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: ColorResources.primaryColor,
            expandedHeight: 50,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: FaIcon(
                FontAwesomeIcons.angleLeft,
                color: Colors.white,
              ),
            ),
            title: Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            centerTitle: false,
            titleSpacing: 0,
            snap: isSnap,
            floating: isFloating,
            pinned: isPinned,
          ),
          SliverToBoxAdapter(
            child:Container(
              color: ColorResources.primaryColor,
              height: Get.height,
              width: Get.width,
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    color: ColorResources.primaryColor,
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: Image.asset('assets/images/logo.jpg').image,
                    ),
                    // child: Column(
                    //   children: [
                    //     SizedBox(height: 32),
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(vertical: 16.0),
                    //       child: TabBar(
                    //         controller: _tabController,
                    //         dividerColor: Colors.transparent,
                    //         indicatorSize: TabBarIndicatorSize.label,
                    //         indicator: BoxDecoration(
                    //           color: ColorResources.whiteColor,
                    //           borderRadius: BorderRadius.circular(30),
                    //           border: Border.all(color: ColorResources.whiteColor, width: 1),
                    //         ),
                    //         tabs: [
                    //           Tab(
                    //             child: Container(
                    //               padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(30),
                    //                 border: Border.all(color: ColorResources.whiteColor, width: 1),
                    //               ),
                    //               child:Text("Phone Number",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    //             ),
                    //           ),
                    //           Tab(
                    //             child: Container(
                    //               padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(30),
                    //                 border: Border.all(color: ColorResources.whiteColor, width: 1),
                    //               ),
                    //               child: Text("Email Address", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                  Positioned(
                    top: 140,
                    bottom: 0,
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32)
                        ),
                        color: ColorResources.whiteColor,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:EdgeInsets.only(top: 32),
                            child: SizedBox(
                              width: Get.width,
                              height: Get.height / 2.5,
                              child: Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 16.0),
                                // child: TabBarView(
                                //   physics: NeverScrollableScrollPhysics(),
                                //   controller: _tabController,
                                //   children: [
                                //     _buildLoginWithPhoneNumber(),
                                   child:  _buildLoginWithEmailAddress(),
                                  // ],
                                // ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
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
                                title: "Sign In".tr,
                                activeColor: true,
                                onPress: () async {
                                  if(_formKey.currentState!.validate()) {
                                    if (_emailCtrl.text.isNotEmpty &&
                                        _passwordCtrl.text.isNotEmpty &&
                                        isValidEmail(_emailCtrl.text)) {
                                        await authController.loginWithEmail(context, email: _emailCtrl.text, password: _passwordCtrl.text);// Navigate to ProfileScreen
                                    } else {
                                      // Show error message
                                      Get.snackbar('Error', 'Please enter valid email and password');
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Don't have an account? "),
                              TextButton(onPressed: (){
                                Get.to(RegisterScreen());
                              },
                                child: Text("Register"),
                              ),
                              SizedBox(height: 16,),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),],
              ),
            ),
          )
        ],

      ),
    );
  }
  Widget _buildLoginWithPhoneNumber(){
    return Form(
      key: _formKey,
      child: Column(
          children:[
            // profile(_fileImage, 100,
            //   name: "User name",
            //   icon: Icons.camera_alt, onPress: () {
            //     pickImage();
            //   },
            // ),
            Spacer(),
            CustomListWidget.customTextformfield(
              controller: _emailCtrl,
              style: TextStyle(color: Colors.grey, fontSize: 16),
              labelText: "Phone Number",
              icon: Icons.phone,
              onChanged: (value) {},
              keyboardType: TextInputType.phone,
              obscureText: false,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value.isEmpty) {
                  return "Phone number is required";
                }
                if(GetUtils.isPhoneNumber(value)){
                  return "Please enter a valid phone number";
                }
              },
            ),
            SizedBox(height: 16),
            CustomListWidget.customTextformfield(
              controller: _passwordCtrl,
              style: TextStyle(color: Colors.grey, fontSize: 16),
              labelText: "Password",
              icon: Icons.lock,
              onChanged: (value) {},
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value.isEmpty && value.length< 8 ) {
                  return "Password is required";
                }
              },
            ),
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
          ]
      ),
    );
  }
  Widget _buildLoginWithEmailAddress(){
    return SizedBox(
      width: Get.width,
      // height: 240,
      child: Form(
        key: _formKey,
        child: Column(
              children:[
                // profile(_fileImage, 100,
                //   name: "User name",
                //   icon: Icons.camera_alt, onPress: () {
                //     pickImage();
                //   },
                // ),
                CustomListWidget.customTextformfield(
                  controller: _emailCtrl,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  labelText: "Email Address",
                  icon: Icons.email,
                  onChanged: (value) {},
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if(value.isEmpty){
                      return "Email is required";
                    }
                    if(!GetUtils.isEmail(value)){
                      return "Please enter a valid email address";
                    }
                  },
                ),
                SizedBox(height: 16),
                CustomListWidget.customTextformfield(
                  controller: _passwordCtrl,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  labelText: "Password",
                  icon: Icons.lock,
                  onChanged: (value) {},
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password is required";
                    }
                    if(value.length < 8){
                      return "Password must be 8 characters long";
                    }
                  },
                ),
                Row(
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ]
          ),
      ),
    );
  }

  //Todo: pickImage
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final File file = File(image.path);
    _fileImage = file;
    setState(() {});
  }
//Other methods about the pickImage
/*Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final File file = File(image.path);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _fileImage = file;
      });
    });
  }*/
}