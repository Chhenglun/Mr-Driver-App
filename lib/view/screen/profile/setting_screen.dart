// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/util/style.dart';
import 'package:scholarar/view/custom/custom_listtile_setting_screen.dart';
import 'package:scholarar/view/screen/profile/profile_screen.dart';
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}
String urlImagProfile ='https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

class _SettingScreenState extends State<SettingScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  Future<void> pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    setState(() {
      _image = selectedImage;
    });
  }

  //create singout function
  // void signOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   Get.offAll(SignInAccountScreen());
  // }
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        body: _buildBody(),
      );
    });
  }
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                  height: Get.height * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorResources.primaryColor.withOpacity(0.7),
                       // Colors.lightBlueAccent,
                        ColorResources.whiteBackgroundColor,

                      ],
                    ),
                    //color: ColorResources.primaryColor,
                  )),
              Container(
                height: Get.height * 0.6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [

                      ColorResources.whiteBackgroundColor,
                      ColorResources.primaryColor.withOpacity(0.1)
                    ],
                  ),
                  color: ColorResources.whiteBackgroundColor,
                ),
              ),
            ],
          ),
          Positioned(top: 40, left: 10, right: 10, child: _buildProfile()),
        ],
      ),
    );
  }

  //Todo : _buildProfile
  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width * 0.9,
        //height: Get.height,
        decoration: BoxDecoration(
          //color: ColorResources.whiteBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              //Todo : Image Profile
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
              //Todo: pickImage
              SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => nextScreen(context, ProfileScreen()),
                icon: Icon(Icons.edit, color: ColorResources.primaryColor),
                label: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: ColorResources.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
               SizedBox(height: 16),
              CustomListWidget.customListTileSettingScreen(
                title: 'Manage Account',
                icon: Icons.credit_card,
                onPress: () {},

              ),
              CustomListWidget.customListTileSettingScreen(
                title: 'Ride Preferences',
                icon: FontAwesomeIcons.gear,
                onPress: () {},
              ),
              CustomListWidget.customListTileSettingScreen(
                title: 'Notifications',
                icon: FontAwesomeIcons.bell,
                onPress: () {},
              ),
              CustomListWidget.customListTileSettingScreen(
                title: 'Security & Privacy',
                icon: FontAwesomeIcons.lock,
                onPress: () {},
              ),
              CustomListWidget.customListTileSettingScreen(
                title: 'Support & Help',
                icon: FontAwesomeIcons.questionCircle,
                onPress: () {},
              ),
              CustomListWidget.customListTileSettingScreen(
                title: 'App Settings ',
                icon: FontAwesomeIcons.infoCircle,
                onPress: () {},
              ),
             SizedBox(height: 32),
             //Drawer(),
              Container(
                height: 2,
                width: Get.width * 0.5,
                color: Colors.grey[300],
              ),
              SizedBox(height: 32),
              CustomListWidget.customListTileSettingScreen(
                title: 'Log Out',
                icon: FontAwesomeIcons.signOutAlt,
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Text("Log Out ", style: textStyleMedium.copyWith(color: ColorResources.blackColor, fontSize: 20),),
                              ],
                            ),
                            //line
                            SizedBox(height: 10,),
                            Container(
                              height: 1,
                              color: ColorResources.primaryColor,
                            ),
                            SizedBox(height: 10,),
                            Icon(Icons.error_outline, color: ColorResources.redColor, size:60,),
                            Row(
                              children: [

                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    'Are you sure, you wish to log Out?',
                                    style: textStyleMedium,
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
                                      color: ColorResources.greyColor.withOpacity(0.5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 32,
                                      ),
                                      child: Text(
                                        'Close',
                                        style: TextStyle(
                                          color: ColorResources.whiteBackgroundColor,
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
                                    color: ColorResources.primaryColor.withOpacity(0.5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 32,
                                    ),
                                    child: Text(
                                      'Log Out',
                                      style: TextStyle(
                                        color: ColorResources.redColor,
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
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
