import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/screen/booking/tracking.dart';

class CloseBooking extends StatefulWidget {
  const CloseBooking({super.key});

  @override
  State<CloseBooking> createState() => _CloseBookingState();
}

class _CloseBookingState extends State<CloseBooking> {
  final Completer<GoogleMapController> _controller = Completer();
  bool locationFetched = false;
  LatLng currentPosition = const LatLng(0,0);


  @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
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
      // Handle errors gracefully
      print("Error getting current location: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
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
            markers: {
              Marker(markerId: const MarkerId("current Position"), position: currentPosition)
            },
            // myLocationButtonEnabled: true,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2.5,
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                      MaterialStatePropertyAll(Colors.red),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: ColorResources.whiteColor,
                        ),
                        Text(
                          'ត្រឡប់ក្រោយ',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )),
              ),
              Spacer(),
              Container(
                child: Stack(
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
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("អ្នកកំពុងប្រេីប្រាស់កម្មវិធី",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20),),
                          SizedBox(height: 5,),
                          const Text("អ្នកកំពុងបេីកការទទួលការកក់...",style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal,fontSize: 14),),
                          SizedBox(height: 50,),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[500]),
                              onPressed: () {
                                nextScreen(context, BookingScreen());
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text("ឈប់ទទួលការកក់",style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]
    );
  }
}
