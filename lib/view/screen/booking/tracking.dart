import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarar/util/app_constants.dart';

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
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
                  markerId: MarkerId("driver"),
                  position: driverPosition,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ),
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
                      height: MediaQuery.sizeOf(context).height * 3 / 9,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(20), topRight: Radius.circular(20))
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5, left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('អ្នកបើកបរនឹងមកដល់ 3​ នាទីទៀត',style: TextStyle(fontSize: 12),),
                              ],
                            ),
                          ),
                          Divider(),
                          GestureDetector(
                            onTap: (){},
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width * 1 / 5,
                                    height: MediaQuery.sizeOf(context).height * 1 / 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(image: NetworkImage(url))
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('លាង ម៉េងហាំង', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                    Row(
                                      children: [
                                        Text('កំពុងធ្វើដំណើរ800មែត្រ . . .',style: TextStyle(fontSize: 12),),
                                        Icon(Icons.location_on, color: Colors.red,size: 16,)
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 10, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('តម្លៃ 8800 រៀល', style: TextStyle(fontSize: 17),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle
                                  ),
                                  child: Stack(
                                      children:[
                                        IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.phone_fill,color: Colors.white,)),
                                      ]
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle
                                  ),
                                  child: Stack(
                                      children:[
                                        IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.chat_bubble_fill,color: Colors.white,)),
                                      ]
                                  ),
                                ),
                                SizedBox(width: 20,),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[400],
                                      padding: EdgeInsets.symmetric(horizontal: 40,vertical: 10)
                                  ),
                                  onPressed: (){},
                                  child: Text("លុបចោលការកក់",style: TextStyle(color: Colors.white,fontSize: 20),),
                                )
                              ],
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