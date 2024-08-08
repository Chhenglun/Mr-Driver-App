// ignore_for_file: prefer_collection_literals

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;

import '../../../controller/auth_controller.dart';
import '../../../controller/booking_process_controller.dart';
import '../../../util/app_constants.dart';
import '../../../util/firebase_api.dart';
import '../../../util/next_screen.dart';
import '../../custom/custom_show_snakbar.dart';
import '../profile/setting_screen.dart';
import 'opening_booking.dart';

class OpenBooking extends StatefulWidget {
  const OpenBooking({super.key});

  @override
  State<OpenBooking> createState() => _OpenBookingState();
}

class _OpenBookingState extends State<OpenBooking> {
  final Completer<GoogleMapController> _controller = Completer();
  final AuthController authController = Get.find<AuthController>();
  final BookingProcessController bookingController = Get.find<BookingProcessController>();
  final FirebaseAPI _firebaseAPI = FirebaseAPI();

  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  bool locationFetched = false;
  LatLng currentPosition = const LatLng(0, 0);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    authController.getDriverProfileController();
    init();
    setDriverMarkerIcon();
    _addCurrentLocationMarker();
    _checkLocationPermissions();
  }

  Set<Marker> _markers() {
    return <Marker>[
      Marker(
        markerId: MarkerId('current_location'),
        position: currentPosition,
        icon: currentLocationIcon,
      ),
    ].toSet();
  }

  void _addCurrentLocationMarker() {
    if (currentLocationIcon != null && currentPosition != null) {
      setState(() {
        _markers().add(
          Marker(
            markerId: MarkerId('current_location'),
            position: currentPosition,
            icon: currentLocationIcon,
          ),
        );
      });
    }
  }

  void setDriverMarkerIcon() async {
    final ByteData byteData = await rootBundle.load('assets/icons/driver_icon.jpg');
    final img.Image? image = img.decodeImage(byteData.buffer.asUint8List());

    // Resize the image
    final img.Image resizedImage = img.copyResize(image!, width: 120, height: 120);

    final ui.Codec codec = await ui.instantiateImageCodec(
      img.encodePng(resizedImage).buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    final ByteData? resizedByteData = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? resizedUint8List = resizedByteData?.buffer.asUint8List();

    final BitmapDescriptor icon = await BitmapDescriptor.fromBytes(resizedUint8List!);
    setState(() {
      currentLocationIcon = icon;
    });
  }

  void init() async {
    await authController.getDriverProfileController();
    setState(() {
      isLoading = false;
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      onPressed: () {
                        nextScreen(context, SettingScreen());
                      },
                      icon: FaIcon(Icons.person, color: Colors.red, size: 30),
                    ),
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
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
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("អ្នកកំពុងប្រេីប្រាស់កម្មវិធី", style: TextStyle(color: Colors.black, fontSize: 20)),
                          const SizedBox(height: 16),
                          Text("សូមបើកការកក់របស់អ្នក....", style: TextStyle(color: Colors.black, fontSize: 16)),
                          SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[500]),
                            onPressed: () async {
                              await _firebaseAPI.initNotifications();
                              String? deviceToken = frmTokenPublic; // Use the token obtained from initNotifications
                              print("Device Token: $deviceToken");
                              String driverId = userNextDetails?["_id"];
                              print("driverId : $driverId");
                              if (deviceToken != null && driverId != null) {
                                List<double> location = [currentPosition.longitude, currentPosition.latitude];
                                print("LocationTest: $location");
                                bookingController.updateToken(deviceToken, driverId, location.toList());
                                isLoading = true;
                                nextScreen(context, OpeningBooking());
                              } else {
                                customShowSnackBar('Device token or driver ID is missing', context, isError: true);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "បេីកទទួលការកក់",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
