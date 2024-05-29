// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/splash_controller.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/view/screen/booking/booking_screen.dart';
import 'package:scholarar/view/screen/chat/chat_screen.dart';
import 'package:scholarar/view/screen/home/home_screen.dart';
import 'package:scholarar/view/screen/profile/profile_screen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget>? listScreen;
  final PageController _pageController = PageController();
  final HomeScreen _homeScreen = HomeScreen();
  final BookingScreen _bookingScreen = BookingScreen();
  final ChatScreen _chatScreen = ChatScreen();
  final ProfileScreen _profileScreen = ProfileScreen();
  // final ScholarshipScreen _scholarshipScreen = ScholarshipScreen();
  // final CoursesScreen _coursesScreen = CoursesScreen();
  // final StoreScreen _storeScreen = StoreScreen();

  @override
  void initState() {
    listScreen = [
      _homeScreen,
      _bookingScreen,
      _chatScreen,
      _profileScreen,
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: GetBuilder<SplashController>(builder: (splash) {
        return Scaffold(
          key: _scaffoldKey,
          body: _buildBody(splash),
          bottomNavigationBar: _buildBottomNavigationBar(splash),
        );
      }),
    );
  }

  // Todo: buildBody
  Widget _buildBody(splash) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      onPageChanged: (index) {
        splash.changeIndex(index);
      },
      children: listScreen!,
    );
  }

  // Todo: buildBottomNavigationBar
  Widget _buildBottomNavigationBar(SplashController splash) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: ColorResources.primaryColor,
        labelTextStyle: MaterialStateProperty.all(TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontStyle: FontStyle.normal)),
      ),
      child: NavigationBar(
        backgroundColor: ColorResources.primaryColor,
        height: 70,
        selectedIndex: splash.selectedIndex,
        onDestinationSelected: (index) {
          splash.changeIndex(index);
          _pageController.jumpToPage(index);
        },
        //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          NavigationDestination(
            icon: FaIcon(Icons.home, color: Colors.white, size: 20,),
            selectedIcon: FaIcon(Icons.home, color: Colors.white, size: 33),
            label: 'Home'.tr,
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.car, color: Colors.white, size: 17,),
            selectedIcon:
                FaIcon(FontAwesomeIcons.car, color: Colors.white, size: 29),
            label: 'Booking'.tr,
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.message, color: Colors.white, size: 17,),
            selectedIcon:
                FaIcon(FontAwesomeIcons.message, color: Colors.white, size: 29),
            label: 'Chat'.tr,
          ),
          NavigationDestination(
            icon: FaIcon(Icons.person_pin, color: Colors.white, size: 20,),
            selectedIcon: FaIcon(Icons.person_pin, color: Colors.white, size: 33),
            label: 'Account'.tr,
          ),
        ],
      ),
    );
  }
}
