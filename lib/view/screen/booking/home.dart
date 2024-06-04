import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng source = LatLng(11.570, 104.875);
  LatLng currentPosition = LatLng(0,0);


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
      });
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
          initialCameraPosition: const CameraPosition( zoom: 14.5, target: source),
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
          markers: {
            Marker(markerId: MarkerId("current Position"), position: currentPosition)
          },
          myLocationButtonEnabled: true,
        ),
         Container(
          alignment: Alignment.bottomCenter,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 3 / 12,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(32), topRight: Radius.circular(32))
                ),
              ),
              Column(
                children: [
                  Text("អ្នកកំពុងប្រេីប្រាស់កម្មវិធី",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20),),
                  Text("អ្នកកំពុងបេីកការទទួលការកក់",style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal,fontSize: 14),),
                ],
              ),
            ],
          ),
        )
      ]
    );
  }
}
