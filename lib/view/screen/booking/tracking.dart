import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/screen/booking/arrive_location.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2.5,
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
                            color: Colors.white,
                          ),
                          Text(
                            'ត្រឡប់ក្រោយ',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                ),
                Spacer(),
                Visibility(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: MediaQuery.sizeOf(context).height * 3 / 8,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft:Radius.circular(20), topRight: Radius.circular(20))
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 5, left: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('120វិនាទី',style: TextStyle(color: Colors.red,fontSize: 12),),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                                        onPressed: (){}, child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 50),
                                      child: Text("12000រៀល",style: TextStyle(color: Colors.black,fontSize: 20),),
                                    )),
                                  )
                                ],
                              ),
                              SizedBox(height: 20,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.location_fill,color: Colors.blue,),
                                    SizedBox(width: 20,),
                                    Text("ចម្ងាយ 200m ពីភ្ញៀវ",style: TextStyle(color: Colors.blue),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
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
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.stop_circle_fill,color: Colors.red,),
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
                                      nextScreen(context, ArriveScreen());
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(vertical: 8,),
                                      child: Text("ទទួលការកក់",style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                                    )
                                ),
                              )
                            ],
                          )
                      ),
                    )
                ),
              ],
            ),
          ]
      ),
    );
  }
}