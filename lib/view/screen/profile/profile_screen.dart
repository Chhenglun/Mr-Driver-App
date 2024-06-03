// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/view/custom/custom_listtile_setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

String urlImagProfile =
    'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  Future<void> pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    setState(() {
      _image = selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: ColorResources.primaryColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
        child: SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                  height: Get.height * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorResources.whiteBackgroundColor,
                        ColorResources.primaryColor,
                      ],
                    ),
                    color: ColorResources.primaryColor,
                  )),
              Container(
                height: Get.height * 0.6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorResources.primaryColor,
                      ColorResources.whiteBackgroundColor,
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
    ));
  }

  //Todo : _buildProfile
  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width * 0.9,
        //height: Get.height,
        decoration: BoxDecoration(
          color: ColorResources.whiteBackgroundColor,
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
              TextButton.icon(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text(
                        'Choose an option',
                        style: TextStyle(color: ColorResources.primaryColor),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Divider(),
                            TextButton.icon(
                              onPressed: () {
                                pickImage(ImageSource.gallery);
                                Get.back();
                              },
                              icon: Icon(Icons.photo),
                              label: Text("Select from Gallery"),
                            ),
                            Padding(padding: EdgeInsets.all(8.0)),
                            TextButton.icon(
                              onPressed: () {
                                pickImage(ImageSource.camera);
                                Get.back();
                              },
                              icon: Icon(Icons.camera_alt_outlined),
                              label: Text("Take a Photo"),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.camera_alt_outlined),
                label: Text(
                  'កែប្រែរូបភាព',
                  style: TextStyle(
                    color: ColorResources.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 16),
              //Todo: More information
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ព័ត៌មានផ្ទាល់ខ្លួន",
                    style: GoogleFonts.notoSerifKhmer(
                      fontSize: 20,
                      color: ColorResources.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              //Todo: ListTile of Profile
              CustomListWidget.customListTile(
                title: 'ឈ្មោះ',
                iconleading: Icons.person,
                onPress: () {},
              ),
              SizedBox(height: 16),
              CustomListWidget.customListTile(
                iconleading: Icons.email,
                title: 'អ៊ីម៉ែល',
                onPress: () {},
              ),
              SizedBox(height: 16),
              CustomListWidget.customListTile(
                title: 'លេខទូរស័ព្ទ',
                iconleading: Icons.phone,
                onPress: () {},
              ),
              SizedBox(height: 16),
              CustomListWidget.customListTile(
                title: 'ថ្ងៃខែឆ្នាំកំណត់',
                iconleading: Icons.calendar_today,
                onPress: () {},
              ),
              SizedBox(height: 16),
              CustomListWidget.customListTile(
                title: 'ភេទ',
                iconleading: Icons.wc,
                onPress: () {},
              ),
              SizedBox(height: 16),
              CustomListWidget.customListTile(
                title: 'អាសយដ្ឋាន',
                iconleading: Icons.location_on,
                onPress: () {},
              ),
              SizedBox(height: 20),
             Container(
              height: 40,
              width: Get.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'កែប្រែព័ត៌មានផ្ទាល់ខ្លួន',
                    style: TextStyle(
                      color: ColorResources.redColor,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    iconColor: ColorResources.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
             ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
