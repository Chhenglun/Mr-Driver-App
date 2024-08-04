// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last



// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/custom/custom_button_widget.dart';
import 'package:scholarar/view/custom/custom_listtile_setting_screen.dart';
import 'package:intl/intl.dart';
import 'package:scholarar/view/screen/home/current_location.dart';
import 'package:scholarar/view/screen/profile/edite_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

String urlImagProfile =
    'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

class _ProfileScreenState extends State<ProfileScreen> {
  AuthController authController = Get.find<AuthController>();
  final baseUrl = "http://ec2-54-82-25-173.compute-1.amazonaws.com:8000/api/users/profile";
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

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    setState(() {
      _image = selectedImage;
    });
  }

  String formatDateOfBirth(String? dateOfBirth) {
    if (dateOfBirth == null) return "N/A";
    DateTime dob = DateTime.parse(dateOfBirth);
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dob);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        var item = authController.userDriverMap?['userDetails'];
        print("User Details: $item"); // Debug print to ensure data is fetched
        return Scaffold(
          backgroundColor: ColorResources.primaryColor,
          body: isLoading != false
              ? Center(child: CircularProgressIndicator())
              : _buildBody(authController),
        );
      },
    );
  }
//Todo: buildBody
  Widget _buildBody(AuthController authController) {
    var userDetails = authController.userDriverMap;
    print("aaa ${userDetails}");
    if (userDetails == null) {
      return Center(child: CircularProgressIndicator());
    }
    //Todo: buildBackground
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
                  top: Get.height * 0.03,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
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
                              // SizedBox(height: 90),
                              Expanded(
                                child:_buildProfile(authController),
                              ),

                            ],
                          ),
                          //write me center left
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
        mainAxisAlignment: MainAxisAlignment.center,
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
        ],
      ),
    );

  }
  //Todo: buildProfile
  Widget _buildProfile(AuthController authController) {
    var userNextDetails = authController.userDriverMap?['userDetails'];
    var userDetails = authController.userDriverMap;
    final idCardImage = userDetails?['id_card_image'];
    final drivingLicenseImage = userDetails?['driving_license_image'];
    final idCardImageUrl = baseUrl + ("/$idCardImage");
    final drivingLicenseImageUrl = baseUrl + ("/$drivingLicenseImage");
    print('ID Card Image URL: $idCardImageUrl');
    print('Driving License Image URL: $drivingLicenseImageUrl');
    return userDetails != null
        ? Container(
      decoration: BoxDecoration(
        color: ColorResources.whiteColor,
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
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ព័ត៌មានរបស់ខ្ញុំ",
                    style: GoogleFonts.notoSerifKhmer(
                      fontSize: 22,
                      color: ColorResources.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Todo: ListTile of Profile
              Container(
                height: Get.height * 0.6,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      CustomListWidget.customListTile(
                        title: userNextDetails?['first_name'] ?? "N/A",
                        iconleading: Icons.person,
                        onPress: () {},
                      ),
                      SizedBox(height: 8),
                      CustomListWidget.customListTile(
                        title: userNextDetails?['last_name'] ?? "N/A",
                        iconleading: Icons.person,
                        onPress: () {},
                      ),
                      SizedBox(height: 8),
                      CustomListWidget.customListTile(
                        iconleading: Icons.email,
                        title: authController.userDriverMap?['email'] ?? "N/A",
                        onPress: () {},
                      ),
                      SizedBox(height: 16),
                      CustomListWidget.customListTile(
                        title: userNextDetails?['phone_number'] ?? "N/A",
                        iconleading: Icons.phone,
                        onPress: () {},
                      ),
                      SizedBox(height: 8),
                      CustomListWidget.customListTile(
                        title: userNextDetails?['gender'] ?? "N/A",
                        iconleading: Icons.wc,
                        onPress: () {},
                      ),
                      SizedBox(height: 8),
                      CustomListWidget.customListTile(
                        title: formatDateOfBirth(userNextDetails?['date_of_birth']),
                        iconleading: Icons.calendar_today,
                        onPress: () {},
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "អត្តសញ្ញាណប័ណ្ឌរបស់អ្នក",
                              style: GoogleFonts.notoSerifKhmer(
                                fontSize: 16,
                                color: ColorResources.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      drivingLicenseImageUrl != null ? Container(
                        height: 200,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: ColorResources.backgroundBannerColor,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(drivingLicenseImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ) : Container(
                        height: 200,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),

                        ),
                        child: Center(
                          child: Text(
                            "មិនមានរូបភាពនេះទេ",
                            style: GoogleFonts.notoSerifKhmer(
                              fontSize: 16,
                              color: ColorResources.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "ប័ណ្ឌបើកបរ",
                              style: GoogleFonts.notoSerifKhmer(
                                fontSize: 16,
                                color: ColorResources.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 200,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: ColorResources.backgroundBannerColor,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(idCardImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      //Todo: buttonSaveEditeProfile
                      CustomButtonWidget.buildButtonClick(
                        title: 'កែប្រែព័ត៌មាន',
                        onPress: () {
                          nextScreen(context, EditeProfileScreen());
                        }, size: 50,
                      ),
                      SizedBox(height: 32,)

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
}