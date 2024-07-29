import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/screen/booking/close_booking.dart';
import 'package:scholarar/view/screen/profile/setting_screen.dart';

class OpenBooking extends StatefulWidget {
  const OpenBooking({super.key});

  @override
  State<OpenBooking> createState() => _OpenBookingState();
}

class _OpenBookingState extends State<OpenBooking> {
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
            markers: {
              Marker(markerId: const MarkerId("current Position"), position: currentPosition,)
            },
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
                            const Text("អ្នកកំពងប្រេីប្រាស់កម្មវិធី",style: TextStyle(color: Colors.black,fontSize: 20),),
                            SizedBox(height: 50,),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[500]),
                                onPressed: () {
                                  nextScreen(context, CloseBooking());
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
