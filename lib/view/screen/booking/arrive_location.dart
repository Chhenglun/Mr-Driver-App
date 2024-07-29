import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/color_resources.dart';


class ArriveScreen extends StatefulWidget {
  const ArriveScreen({super.key});

  @override
  State<ArriveScreen> createState() => _ArriveScreenState();
}

class _ArriveScreenState extends State<ArriveScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng destination = LatLng(11.544, 104.8112);
  List<LatLng> polyLineCoordinates = [];
  LatLng currentPosition = destination;
  LatLng driverPosition = LatLng(11.570, 104.875);
  StreamSubscription<Position>? positionStreamSubscription;
  String url = "https://toppng.com/uploads/preview/user-account-management-logo-user-icon-11562867145a56rus2zwu.png";
  Timer? driverTimer;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
  }

  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    driverTimer?.cancel();
    super.dispose();
  }

  void getPolyPoint() async{
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConstants.google_key_api,
      PointLatLng(currentPosition.latitude, currentPosition.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      polyLineCoordinates.clear();
      result.points.forEach((PointLatLng point) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        print("=====>>>>>>>Polyline coordinates updated");
      });
    } else {
      print('=====>>>>>>No points found or error in fetching points');
    }
  }
  void _checkLocationPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
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
      // Permissions are denied forever, handle appropriately.
      print('=====>>>>>>Location permissions are permanently denied.');
      return;
    }

    getCurrentLocation();
    listenToPositionStream();
  }
  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      getPolyPoint();
      _simulateDriverMovement();
    });
  }
  void listenToPositionStream() {
    positionStreamSubscription = Geolocator.getPositionStream().listen((Position newPosition) {
      print('=====>>>>>>New position obtained: ${newPosition.latitude}, ${newPosition.longitude}');
      setState(() {
        currentPosition = LatLng(newPosition.latitude, newPosition.longitude);
        _animateCameraToPosition(newPosition);
        getPolyPoint();
      });
    });
  }

  Future<void> _animateCameraToPosition(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
  }

  void _simulateDriverMovement() {
    const duration = Duration(seconds: 5);
    driverTimer = Timer.periodic(duration, (timer) {
      setState(() {
        // Simulate driver movement
        double newLat = driverPosition.latitude + (Random().nextDouble() * 0.001 - 0.0005);
        double newLng = driverPosition.longitude + (Random().nextDouble() * 0.001 - 0.0005);
        driverPosition = LatLng(newLat, newLng);

        getPolyPoint();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentPosition,
                zoom: 14.5,
              ),
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: polyLineCoordinates,
                  color: Colors.green,
                  width: 6,
                )
              },
              markers: {
                Marker(
                  markerId: MarkerId("user"),
                  position: currentPosition,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                ),
                Marker(
                  markerId: MarkerId("destination"),
                  position: destination,
                ),
              },
            ),
            Visibility(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      height: MediaQuery.sizeOf(context).height * 3 / 9,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(20), topRight: Radius.circular(20))
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 70,
                                  width: 70,
                                  child: Image(image: NetworkImage(url,))
                              ),
                              SizedBox(width: 20,),
                              Text("User123",style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                              Container(
                                width: MediaQuery.of(context).size.width / 3.5,
                                margin: EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green[500]
                                      ),
                                        child: IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.phone_fill,color: Colors.white,))),
                                    SizedBox(width: 20,),
                                    Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green[500]
                                        ),
                                        child: IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.chat_bubble_fill,color: Colors.white,)))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.map_pin_ellipse,color: Colors.black,),
                                SizedBox(width: 20,),
                                Text("St528",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),)
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.stop_circle_fill,color: ColorResources.redColor,),
                                SizedBox(width: 20,),
                                Text("Fun mall",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),)
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[500]),
                                onPressed: () {

                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 16,),
                                  child: Text("បានមកដល់ទីតាំង",style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                                )
                            ),
                          )
                        ],
                      )
                  ),
                )
            ),
          ]
      ),
    );
  }
}