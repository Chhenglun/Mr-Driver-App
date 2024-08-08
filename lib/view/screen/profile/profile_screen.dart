import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_project2/controller/auth_controller.dart';
import 'package:capstone_project2/util/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../util/color_resources.dart';
import '../../custom/custom_button_widget.dart';
import '../../custom/custom_listtile_setting_screen.dart';
import 'edite_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

String urlImagProfile = 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

class _ProfileScreenState extends State<ProfileScreen> {
  AuthController authController = Get.find<AuthController>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
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
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildBody(authController),
        );
      },
    );
  }

  Widget _buildBody(AuthController authController) {
    var userDetails = authController.userDriverMap?['userDetails'];
    print("User Details Map: $userDetails");

    if (userDetails == null) {
      return Center(child: CircularProgressIndicator());
    }

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
                  Expanded(
                    child: Container(
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
                                IconButton(onPressed: () {
                                  Get.back();
                                }, icon: FaIcon(FontAwesomeIcons.angleLeft, color: ColorResources.whiteColor)),
                                Text('ត្រឡប់ក្រោយ', style: GoogleFonts.notoSerifKhmer(fontSize: 14, color: ColorResources.whiteColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      color: ColorResources.whiteBackgroundColor,
                    ),
                  ),
                ],
              ),
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
                            Expanded(
                              child: _buildProfile(authController),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 50,
                          child: _buildImageProfile(authController),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageProfile(AuthController authController) {
    var profileImageUrl = authController.userDriverMap?['userDetails']?['profile_image_url'] ?? urlImagProfile;
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
                image: CachedNetworkImageProvider(profileImageUrl),
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

  Widget _buildProfile(AuthController authController) {
    var userDetails = authController.userDriverMap?['userDetails'];

    dynamic idCardImageUrl = userDetails?['id_card_image_url'];
    dynamic drivingLicenseImageUrl = userDetails?['driving_license_image_url'];
    print("idCardImageUrl: $idCardImageUrl");
    print("drivingLicenseImageUrl: $drivingLicenseImageUrl");

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
              Container(
                height: Get.height * 0.6,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      CustomListWidget.customListTile(
                        title: userDetails['first_name'] ?? "N/A",
                        iconleading: Icons.person,
                        onPress: () {},
                      ),
                      SizedBox(height: 8),
                      CustomListWidget.customListTile(
                        title: userDetails['last_name'] ?? "N/A",
                        iconleading: Icons.person,
                        onPress: () {},
                      ),
                      SizedBox(height: 8),
                      CustomListWidget.customListTile(
                        iconleading: Icons.email,
                        title: userDetails['email'] ?? "N/A",
                        onPress: () {},
                      ),
                      SizedBox(height: 16),
                      CustomListWidget.customListTile(
                        title: userDetails['phone_number'] ?? "N/A",
                        iconleading: Icons.phone,
                        onPress: () {},
                      ),
                      SizedBox(height: 8),
                      CustomListWidget.customListTile(
                        title: userDetails['gender'] ?? "N/A",
                        iconleading: Icons.wc,
                        onPress: () {},
                      ),
                      SizedBox(height: 8),
                      CustomListWidget.customListTile(
                        title: formatDateOfBirth(userDetails['date_of_birth']),
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
                            image: NetworkImage(drivingLicenseImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      CustomButtonWidget.buildButtonClick(
                        title: 'កែប្រែព័ត៌មាន',
                        onPress: () {
                          nextScreen(context, EditeProfileScreen());
                        },
                        size: 50,
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        : Center(child: CircularProgressIndicator());
  }
}
