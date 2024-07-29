// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/view/custom/custom_listtile_setting_screen.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

String urlImagProfile =
    'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

class _ProfileScreenState extends State<ProfileScreen> {
  AuthController authController = Get.find<AuthController>();
  bool isLoading = true;
  final baseUrl = "http://ec2-54-82-25-173.compute-1.amazonaws.com:8000/api/users/profile";


  init() async {
    await authController.getDriverProfileController();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    setState(() {
      _image = selectedImage;
    });
  }

  String formatDateOfBirth(String dateOfBirth) {
    // Parse the date of birth into a DateTime object
    DateTime dob = DateTime.parse(dateOfBirth);
    // Create a DateFormat for the desired format
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    // Format the date of birth
    String formattedDob = formatter.format(dob);
    return formattedDob;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: ColorResources.primaryColor,
              ),
            ),
            title: Text(
              'ព័ត៌មានផ្ទាល់ខ្លួន',
              style: GoogleFonts.notoSerifKhmer(
                fontSize: 20,
                color: ColorResources.primaryColor,
              ),
            ),
            centerTitle: true,
            backgroundColor: ColorResources.backgroundBannerColor,
          ),
          body: _buildBody(authController),
        );
      },
    );
  }

  Widget _buildBody(AuthController authController) {

    return SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
      child: _buildProfile(authController),
    ));
  }

  Widget _buildProfile(AuthController authController) {
    final userDetails = authController.userDriverMap?['userDetails'];
    final idCardImage = userDetails['id_card_image'];
    final drivingLicenseImage = userDetails['driving_license_image'];

    final idCardImageUrl = baseUrl + ("/$idCardImage");
    final drivingLicenseImageUrl = baseUrl + ("/$drivingLicenseImage");
    print('ID Card Image URL: $idCardImageUrl');
    print('Driving License Image URL: $drivingLicenseImageUrl');
    return Container(
      decoration: BoxDecoration(
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
            //SizedBox(height: 16),
            //Todo: More information
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "ព័ត៌មានផ្ទាល់ខ្លួន",
                  style: GoogleFonts.notoSerifKhmer(
                    fontSize: 16,
                    color: ColorResources.primaryColor,
                  ),
                ),
              ],
            ),
            //Todo: ListTile of Profile
            CustomListWidget.customListTile(
              title: authController.userDriverMap?['userDetails']?['first_name'],
              iconleading: Icons.person,
              onPress: () {},
            ),
            //SizedBox(height: 16),
            CustomListWidget.customListTile(
              title: authController.userDriverMap?['userDetails']['last_name'],
              iconleading: Icons.person,
              onPress: () {},
            ),
            //SizedBox(height: 16),
            CustomListWidget.customListTile(
              iconleading: Icons.email,
              title: authController.userDriverMap?['email'] ?? "N/A",
              onPress: () {},
            ),
            //SizedBox(height: 16),
            CustomListWidget.customListTile(
              title: authController.userDriverMap?['userDetails']['phone_number'] ?? "N/A",
              iconleading: Icons.phone,
              onPress: () {},
            ),
            //SizedBox(height: 16),
            CustomListWidget.customListTile(
              title: authController.userDriverMap?['userDetails']['gender'] ?? "N/A",
              iconleading: Icons.calendar_today,
              onPress: () {},
            ),
           // SizedBox(height: 16),
            CustomListWidget.customListTile(
              title: formatDateOfBirth(
                  authController.userDriverMap?['userDetails']['date_of_birth'] ??
                      "Date of Birth"),
              iconleading: Icons.wc,
              onPress: () {},
            ),
            SizedBox(height: 16),
            //Todo: DrivingID
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
                color: Colors.white,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(idCardImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
