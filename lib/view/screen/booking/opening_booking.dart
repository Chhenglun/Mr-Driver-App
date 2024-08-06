// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/controller/booking_process_controller.dart';
import 'package:scholarar/util/alert_dialog.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/custom/custom_show_snakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'driver_start_pick_passenger_screen.dart';

class OpeningBooking extends StatefulWidget {
  const OpeningBooking({super.key});

  @override
  State<OpeningBooking> createState() => _OpeningBookingState();
}

class _OpeningBookingState extends State<OpeningBooking> {
  SharedPreferences? sharedPreferences;
  final AuthController authController = Get.find<AuthController>();
  final BookingProcessController bookingController = Get.find<BookingProcessController>();
  final Completer<GoogleMapController> _controller = Completer();
  bool locationFetched = false;
  LatLng currentPosition = const LatLng(0, 0);
  bool isLoading = true;
  /*FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;*/
  /*final FirebaseAPI _firebaseAPI = FirebaseAPI();*/
  String? _tripID; // To store the tripID
  bool isDialogVisible = false; // To track dialog visibility

  @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
    init();
    _configureFirebaseListeners();
  }

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await authController.getDriverProfileController();
    setState(() {
      isLoading = false;
    });
  }

  void _configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage received');
      if (message.data.containsKey('tripId')) {
        setState(() {
          _tripID = message.data['tripId'];
        });
        print('Received tripID: $_tripID');
        if (!isDialogVisible) {
          //_showCustomNotificationDialog(context, message.data['title'], message.data['body']);
          customNotificationDialog(
            context: Get.context!,
            title: message.notification!.title!,
            body: message.notification!.body!,
            onTap: () {
              FlutterAppBadger.removeBadge();
              //nextScreen(context, AcceptedScreen());
              String driverId = authController.userDriverMap?['userDetails']['_id'];
              print("driverId : $driverId");
              if (driverId != null && _tripID != null) {
                setState(() {
                  isLoading = true;
                  isDialogVisible = false;
                });
                List<double> location = [currentPosition.longitude, currentPosition.latitude];
                bookingController.acceptBooking(driverId, _tripID! ,location);
                //bookingController.deleteDeviceToken(driverId);

              } else {
                customShowSnackBar('Driver ID is missing', context, isError: true);
                setState(() {
                  isDialogVisible = false;
                });
              }
            },
            // btnText: 'Go To Trip'.tr,
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp received');
      if (message.data.containsKey('tripId')) {
        setState(() {
          _tripID = message.data['tripId'];
        });
        print('Received tripID: $_tripID');
        if (!isDialogVisible) {
          customNotificationDialog(
            context: Get.context!,
            title: message.notification!.title!,
            body: message.notification!.body!,
            onTap: () {
              FlutterAppBadger.removeBadge();
              //nextScreen(context, AcceptedScreen());
              String driverId = authController.userDriverMap?['userDetails']['_id'];
              print("driverId : $driverId");
              if (driverId != null && _tripID != null) {
                setState(() {
                  isLoading = true;
                  isDialogVisible = false;
                });
                List<double> location = [currentPosition.longitude, currentPosition.latitude];
                bookingController.acceptBooking(driverId, _tripID! ,location);
                //bookingController.deleteDeviceToken(driverId);

              } else {
                customShowSnackBar('Driver ID is missing', context, isError: true);
                setState(() {
                  isDialogVisible = false;
                });
              }
            },
            // btnText: 'Go To Trip'.tr,
          );
          //_showCustomNotificationDialog(context, message.data['title'], message.data['body']);
        }
      }
    });
  }


  Future<void> _showCustomNotificationDialog(BuildContext context, String? title, String? body) async {
    isDialogVisible = true;
    await customNotificationDialog(
      context: context,
      title: title ?? 'Notification',
      body: body ?? 'You have a new notification',
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          isDialogVisible = false;
        });
        String driverId = authController.userDriverMap?['userDetails']['_id'];
        print("driverId : $driverId");
        if (driverId != null && _tripID != null) {
          setState(() {
            isLoading = true;
            isDialogVisible = false;
          });
          List<double> location = [currentPosition.longitude, currentPosition.latitude];
          bookingController.acceptBooking(driverId, _tripID! ,location);
          //bookingController.deleteDeviceToken(driverId);

        } else {
          customShowSnackBar('Driver ID is missing', context, isError: true);
          setState(() {
            isDialogVisible = false;
          });
        }
      },
    ).then((_) {
      setState(() {
        isDialogVisible = false;
      });
    });
  }


  void _checkLocationPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('=====>>>>>>Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('=====>>>>>>Location permissions are denied');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print('=====>>>>>>Location permissions are permanently denied.');
      return;
    }

    getCurrentLocation();
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
        locationFetched = true;
      });
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(currentPosition));
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var userNextDetails = authController.userDriverMap?['userDetails'];
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(zoom: 14.5, target: currentPosition),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              if (locationFetched) {
                controller.animateCamera(CameraUpdate.newLatLng(currentPosition));
              }
            },
            markers: {
              Marker(markerId: const MarkerId("current Position"), position: currentPosition)
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Container(
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 3 / 12,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 3 / 12,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "អ្នកកំពុងប្រេីប្រាស់កម្មវិធី",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(height: 5),
                          const Text(
                            "អ្នកកំពុងបេីកការទទួលការកក់...",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                          SizedBox(height: 50),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[500]),
                            onPressed: () async {
                              String driverId = userNextDetails?["_id"];
                              print("driverId : $driverId");
                              if (driverId != null) {
                                bookingController.deleteDeviceToken(driverId);
                                setState(() {
                                  isLoading = true;
                                });
                              } else {
                                customShowSnackBar('Driver ID is missing', context, isError: true);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.cancel, color: Colors.white),
                                  SizedBox(width: 25),
                                  Text(
                                    "ឈប់ទទួលការកក់",
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
