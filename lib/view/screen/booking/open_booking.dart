import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/controller/get_booking_request.dart';
import 'package:scholarar/util/alert_dialog.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/firebase_api.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/custom/custom_show_snakbar.dart';
import 'package:scholarar/view/screen/booking/close_booking.dart';
import 'package:scholarar/view/screen/booking/tracking.dart';
import 'package:scholarar/view/screen/profile/setting_screen.dart';

class OpenBooking extends StatefulWidget {
  const OpenBooking({super.key});

  @override
  State<OpenBooking> createState() => _OpenBookingState();
}

class _OpenBookingState extends State<OpenBooking> {
  final Completer<GoogleMapController> _controller = Completer();
  final AuthController authController = Get.find<AuthController>();
  final GetBookingRequestController bookingController = Get.find<GetBookingRequestController>();
  final FirebaseAPI _firebaseAPI = FirebaseAPI();
  bool locationFetched = false;
  LatLng currentPosition = const LatLng(0,0);
  bool isLoading = false;
  BitmapDescriptor CurrentLocationIcon = BitmapDescriptor.defaultMarker;
  //Todo: init
  Set<Marker> _markers() {
    return <Marker>[
      Marker(
        markerId: MarkerId('current_location'),
        position: currentPosition!,
        icon: CurrentLocationIcon!,
      ),
    ].toSet();
  }
  @override
  void initState() {
    setState(() {
      init();
    });
    setCustomerMarkerIcon();
    _addCurrentLocationMarker();
    super.initState();
    _checkLocationPermissions();
  }

  void _addCurrentLocationMarker() {
    if (CurrentLocationIcon != null && currentPosition != null) {
      setState(() {
        _markers().add(
          Marker(
            markerId: MarkerId('current_location'),
            position: currentPosition!,
            icon: CurrentLocationIcon!,
          ),
        );
      });
    }
  }
  void setCustomerMarkerIcon() async {
    final ByteData byteData =
    await rootBundle.load('assets/icons/user_icon.jpg');
    final img.Image? image = img.decodeImage(byteData.buffer.asUint8List());

    // Resize the image
    final img.Image resizedImage =
    img.copyResize(image!, width: 120, height: 120);

    final ui.Codec codec = await ui.instantiateImageCodec(
      img.encodePng(resizedImage).buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    final ByteData? resizedByteData =
    await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? resizedUint8List = resizedByteData?.buffer.asUint8List();

    final BitmapDescriptor icon =
    await BitmapDescriptor.fromBytes(resizedUint8List!);
    setState(() {
      CurrentLocationIcon = icon;
    });
  }

  Future<void> init() async {
    await authController.getDriverProfileController();
    await bookingController.getDriverID();
    setState(() {
      isLoading = false;
    });
  }
  //Todo: initState
 /* @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
    authController.getDriverProfileController();
  }*/
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
      // Handle errors gracefully
      print("Error getting current location: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    var userNextDetails = authController.userDriverMap?['userDetails'];
    var userIDInfo = bookingController.driverIDList;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children:[
          GoogleMap(
            initialCameraPosition:  CameraPosition( zoom: 14.5, target: currentPosition),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              if (locationFetched) {
                controller.animateCamera(CameraUpdate.newLatLng(currentPosition));
              }
            },
            markers: _markers(),

            // myLocationButtonEnabled: true,
          ),
          Stack(
            children:[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                          child: IconButton(onPressed: (){nextScreen(context, SettingScreen());}, icon: FaIcon(Icons.person, color: Colors.red, size: 30,),)),
                    ),
                  ),
                  Spacer(),
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.sizeOf(context).height * 3 / 12,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(32), topRight: Radius.circular(32))
                        ),
                      ),
                      Container(
                        height: MediaQuery.sizeOf(context).height * 3 / 12,
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("អ្នកកំពុងប្រេីប្រាស់កម្មវិធី",style: TextStyle(color: Colors.black,fontSize: 20),),
                            const SizedBox(height: 16,),
                            Text("សូមបើកការកក់របស់អ្នក....",style: TextStyle(color: Colors.black,fontSize: 16),),
                            SizedBox(height: 16,),
                            /*if (userIDInfo != null && userIDInfo.isNotEmpty)
                              Text("Passenger ID: ${userIDInfo[0]['passenger_id']['_id']}",
                                style: TextStyle(color: Colors.black, fontSize: 16),),
                            SizedBox(height: 8,),*/
                            //DRIVER ID
                            /*if (userIDInfo != null && userIDInfo.isNotEmpty)
                              Text("Driver ID: ${userIDInfo[0]['_id']}",
                                style: TextStyle(color: Colors.black, fontSize: 16),),*/
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[500]),
                              // onPressed: () async {
                              //   await _firebaseAPI.initNotifications();
                              //   String? deviceToken = frmTokenPublic; // Use the token obtained from initNotifications
                              //   String driverId = userNextDetails?["_id"];// Replace with actual driver ID
                              //   _bookingController.updateToken(deviceToken!, driverId);
                              // },
                              onPressed: () async {
                                await _firebaseAPI.initNotifications();
                                String? deviceToken = frmTokenPublic; // Use the token obtained from initNotifications
                                String driverId = userNextDetails?["_id"]; // Ensure this is the correct driver ID
                                if (deviceToken != null && driverId != null) {
                                  bookingController.updateToken(deviceToken, driverId);
                                  isLoading = true;
                                  //customShowSnackBar('ការបើកការកក់របស់អ្នកទទួលបានជោគជ័យ', context, isError: false);
                                  nextScreen(context, CloseBooking());
                                } else {
                                  customShowSnackBar('Device token or driver ID is missing', context, isError: true);

                                }
                              },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: const Text("បេីកការទទួលការកក់",style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                                ),
                            )

                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
             ],
          ),

        ]
      ),
    );
  }
}
