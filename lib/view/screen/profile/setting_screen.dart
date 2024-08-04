// ignore_for_file: prefer_const_constructors

// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/util/style.dart';
import 'package:scholarar/view/custom/custom_button_widget.dart';
import 'package:scholarar/view/custom/custom_listtile_setting_screen.dart';
import 'package:scholarar/view/screen/profile/profile_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

String urlImagProfile =
    'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

class _SettingScreenState extends State<SettingScreen> {
  final ImagePicker _picker = ImagePicker();
  bool isLoading = true;
  XFile? _image;
  Future<void> pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    setState(() {
      _image = selectedImage;
    });
  }

  AuthController authController = Get.find<AuthController>();
  Future<void> init() async {
    await authController.getDriverProfileController();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        backgroundColor: ColorResources.primaryColor,
        body: isLoading != false
            ? Center(child: CircularProgressIndicator(

        ))
            : _buildBody(authController),
      );
    });
  }
  //Todo: _buildBody
  Widget _buildBody(AuthController authController) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
            width: Get.width,
            height: Get.height,
            color: ColorResources.primaryColor,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(onPressed: (){
                                  Get.back();
                                }, icon: FaIcon(FontAwesomeIcons.angleLeft, color: ColorResources.whiteColor,)),
                                Text('ត្រឡប់ក្រោយ', style: GoogleFonts.notoSerifKhmer(fontSize: 14, color: ColorResources.whiteColor),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                    Expanded(child: Container(
                      width: Get.width,
                      height: Get.height,
                      color: ColorResources.whiteBackgroundColor,
                    )),
                  ],
                ),
                //Todo: Profile
                Positioned(
                  top: Get.height * 0.05,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                color: ColorResources.primaryColor,
                                height: 100,
                                width: Get.width,
                              ),
                              //Todo: Setting
                              Expanded(
                                child:_buildSetting(authController),
                              ),
                            ],
                          ),
                          //Todo: ImageProfile
                          Positioned(
                            top: 50,  // Adjust the vertical position as needed
                            child: _buildImageProfile(authController),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
        // child: _buildProfile(authController),
      ),
    );
  }
//Todo : buildImageProfile
  Widget _buildImageProfile(AuthController authController) {
    var userNextDetails = authController.userDriverMap?['userDetails'];
    var userDetails = authController.userDriverMap;
    return Container(
      padding: EdgeInsets.only(right: 20),
      alignment: Alignment.center,
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _image == null
              ? Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(urlImagProfile),
                fit: BoxFit.cover,
              ),
            ),
          )
              : CircleAvatar(
            backgroundImage: Image.file(
              File(_image!.path),
            ).image,
            radius: 50,
          ),
          Text(
            // when get first_name success show it as UPPER CASE
            authController.userDriverMap?['userDetails']['first_name'].toString().toUpperCase()  ?? "Username",
            style: TextStyle(color: ColorResources.primaryColor, fontSize: 16),
          ),
          // TextButton.icon(
          //   onPressed: () {
          //     Get.dialog(
          //       AlertDialog(
          //         title: Text(
          //           'ជ្រើសរើសរូបភាព',
          //           style:
          //           TextStyle(color: ColorResources.primaryColor),
          //         ),
          //         content: SingleChildScrollView(
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: <Widget>[
          //               Divider(),
          //               TextButton.icon(
          //                 onPressed: () {
          //                   pickImage(ImageSource.gallery);
          //                   Get.back();
          //                 },
          //                 icon: Icon(Icons.photo),
          //                 label: Text("ជ្រើសរើសរូបភាព" , style: TextStyle(color: ColorResources.blackColor)),
          //               ),
          //               Padding(padding: EdgeInsets.all(8.0)),
          //               TextButton.icon(
          //                 onPressed: () {
          //                   pickImage(ImageSource.camera);
          //                   Get.back();
          //                 },
          //                 icon: Icon(Icons.camera_alt_outlined),
          //                 label: Text("បើកកាមេរ៉ា", style: TextStyle(color: ColorResources.blackColor)),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          //   icon: Icon(Icons.camera_alt_outlined),
          //   label: Text(
          //     'កែប្រែរូបភាព',
          //     style: TextStyle(
          //       color: ColorResources.primaryColor,
          //       fontSize: 16,
          //     ),
          //   ),
          // ),
        ],
      ),
    );

  }
  //Todo: _buildProfile
  Widget _buildSetting(AuthController authController) {
    var userDetails = authController.userDriverMap;
    return userDetails != null
        ? Container(
      decoration: BoxDecoration(
        color: ColorResources.whiteBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(
            children: [
              SizedBox(height: 80),
              // Todo: ListTile of Profile
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      CustomListWidget.customListTileSettingScreen(
                        title: 'ព័ត៌មានរបស់ខ្ញុំ',
                        icon: Icons.person_outline,
                        onPress: () {
                          nextScreen(context, ProfileScreen());
                        },
                      ),
                      SizedBox(height: 16),
                      CustomListWidget.customListTileSettingScreen(
                        title: 'ប្រវត្តិរបស់ខ្ញុំ',
                        icon: FontAwesomeIcons.history,
                        onPress: () {},
                      ),
                      SizedBox(height: 16),
                      CustomListWidget.customListTileSettingScreen(
                        title: 'ការជូនដំណឹង',
                        icon: FontAwesomeIcons.bell,
                        onPress: () {},
                      ),
                      SizedBox(height: 16),
                      CustomListWidget.customListTileSettingScreen(
                        title: 'ទំនាក់ទំនងយើង',
                        icon: FontAwesomeIcons.phone,
                        onPress: () {},
                      ),
                      SizedBox(height: 32),
                      //Todo: Logout
                      _buildLogout(authController),

                      SizedBox(height: 16),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    )
        : Center(child: CircularProgressIndicator());
  }
  //Todo: _buildLogout
  Widget _buildLogout (AuthController authController){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "ចាកចេញ",
                          style: textStyleMedium.copyWith(
                              color: ColorResources.blackColor,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    //line
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 1,
                      color: ColorResources.primaryColor,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Icon(
                      Icons.error_outline,
                      color: ColorResources.redColor,
                      size: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'តេីអ្នកប្រាកដឬទេថាចង់ចាកចេញ?',
                            style: textStyleMedium.copyWith(
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actionsPadding: EdgeInsets.symmetric(
                    vertical: 16, horizontal: 16),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(16)),
                              color: ColorResources.greyColor
                                  .withOpacity(0.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 26,
                              ),
                              child: Text(
                                'ថយក្រោយ',
                                style: TextStyle(
                                  color: ColorResources
                                      .blackColor,
                                ),
                              ),
                            )),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          await authController.signOut(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                            color: ColorResources.primaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 30,
                            ),
                            child: Text(
                              'ចាកចេញ',
                              style: TextStyle(
                                color: ColorResources.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.signOutAlt,
              color: ColorResources.primaryColor,
            ),
            SizedBox(width: 16),
            Text(
              'ចាកចេញ',
              style: TextStyle(
                color: ColorResources.primaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
