// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarar/controller/get_booking_request.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'package:scholarar/view/app/app_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverPickPassengerScreen extends StatefulWidget {
  const DriverPickPassengerScreen({super.key});

  @override
  State<DriverPickPassengerScreen> createState() => _DriverPickPassengerScreenState();
}

class _DriverPickPassengerScreenState extends State<DriverPickPassengerScreen> {
  GetBookingRequestController bookingController = Get.find<GetBookingRequestController>();
  final Completer<GoogleMapController> _controller = Completer();
  bool toSelected = false;
  static const LatLng destination = LatLng(11.544, 104.8112);
  List<LatLng> polyLineCoordinates = [];
  LatLng currentPosition = destination;
  LatLng driverPosition = LatLng(11.570, 104.875);
  StreamSubscription<Position>? positionStreamSubscription;
  String url = "https://toppng.com/uploads/preview/user-account-management-logo-user-icon-11562867145a56rus2zwu.png";
  Timer? driverTimer;
  Uri dialnumber = Uri(scheme: 'tel', path: '012345678');
  BitmapDescriptor CurrentIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor DestinationIcon = BitmapDescriptor.defaultMarker;
  bool isLoading = true;
  //phone Number formart
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return "(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6, 10)}";
    } else {
      return phoneNumber;
    }
  }

  Set<Marker> _markers() {
    return <Marker>[
      Marker(
        markerId: MarkerId('current_location'),
        position: currentPosition,
        icon: CurrentIcon!,
      ),
      Marker(
        markerId: MarkerId('destination'),
        position: destination,
        icon: DestinationIcon!,
      ),
    ].toSet();
  }
  void setCurrentIcon() async {
    final ByteData byteData = await rootBundle.load('assets/icons/user_icon.jpg');
    final img.Image? image = img.decodeImage(byteData.buffer.asUint8List());

    // Resize the image
    final img.Image resizedImage = img.copyResize(image!, width: 120, height: 120);

    final ui.Codec codec = await ui.instantiateImageCodec(
      img.encodePng(resizedImage).buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    final ByteData? resizedByteData = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? resizedUint8List = resizedByteData?.buffer.asUint8List();

    final BitmapDescriptor Currenticon = await BitmapDescriptor.fromBytes(resizedUint8List!);
    setState(() {
      CurrentIcon = Currenticon;
    });
  }
  void setDestinationIcon() async {
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

    final BitmapDescriptor destinationIcon = await BitmapDescriptor.fromBytes(resizedUint8List!);
    setState(() {
      DestinationIcon = destinationIcon;
    });
  }

  Future<void> callNumber() async {
    await launchUrl(dialnumber);
  }
  /*Future<void> directCall() async {
    await FlutterPhoneDirectCaller.callNumber('012345678');
  }*/
  Future<void> init() async {
    await bookingController.getTripInfo(bookingController.tripID);
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    setState(() {
      init();
    });
    setCurrentIcon();
    setDestinationIcon();
    super.initState();
    //_addCurrentLocationMarker();
    _checkLocationPermissions();
  }

  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    driverTimer?.cancel();
    super.dispose();
  }

  void getPolyPoint() async {
    PolylinePoints polylinePoints = PolylinePoints();

    // Create a PolylineRequest object with required parameters
    PolylineRequest request = PolylineRequest(
      origin: PointLatLng(currentPosition.latitude, currentPosition.longitude),
      destination: PointLatLng(destination.latitude, destination.longitude),
      mode: TravelMode.driving, // Set the mode of travel if required
    );

    try {
      // Pass the request object and API key to getRouteBetweenCoordinates
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: request,
        googleApiKey: AppConstants.google_key_api,
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
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void _checkLocationPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //print('=====>>>>>>Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //print('=====>>>>>>Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // print('=====>>>>>>Location permissions are permanently denied.');
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
    positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position newPosition) {
          //print('=====>>>>>>New position obtained: ${newPosition.latitude}, ${newPosition.longitude}');
          setState(() {
            currentPosition = LatLng(newPosition.latitude, newPosition.longitude);
            _animateCameraToPosition(newPosition);
            getPolyPoint();
          });
        });
  }

  Future<void> _animateCameraToPosition(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
  }

  void _simulateDriverMovement() {
    const duration = Duration(seconds: 5);
    driverTimer = Timer.periodic(duration, (timer) {
      setState(() {
        double newLat =
            driverPosition.latitude + (Random().nextDouble() * 0.001 - 0.0005);
        double newLng =
            driverPosition.longitude + (Random().nextDouble() * 0.001 - 0.0005);
        driverPosition = LatLng(newLat, newLng);
        getPolyPoint();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var userTripInfoDetail = bookingController.tripInfo;
    //Todo: fomart distance
    double? distance = userTripInfoDetail?["distance_between_passenger_and_driver"];
    String formattedDistance = distance != null ? "${distance.toStringAsFixed(2)} km" : "N/A";
    //Todo: call format phone number
    String? phoneNumber = userTripInfoDetail?["passenger_phone_number"];
    String formattedPhoneNumber = phoneNumber != null ? formatPhoneNumber(phoneNumber) : "N/A";

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: currentPosition == destination
            ? Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentPosition,
                zoom: 14.5,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: polyLineCoordinates,
                  color: Colors.green,
                  width: 6,
                ),
              },
              markers: _markers(),
            ),
            Visibility(
              visible: currentPosition != destination,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 3 / 9,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: ColorResources.backgroundBannerColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 16),
                            child: Text(
                              "សូមចុចប៊ូតុងខាងក្រោមដើម្បីចាប់ផ្តើមការដឹកជញ្ជូន",
                              style: TextStyle(
                                color: ColorResources.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Divider(thickness: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(url),
                                    ),
                                    //SizedBox(width: 20),
                                  ],
                                ),
                                SizedBox(width: 16),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                                    onPressed: () {},
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              "តម្លៃការដឹកជញ្ជូន: ",
                                              style: TextStyle(color: ColorResources.blackColor, fontSize: 14,
                                              ),
                                          ),
                                          Text(
                                            overflow: TextOverflow.ellipsis,
                                            "${(userTripInfoDetail?["cost"]?.toDouble()?.toInt().toString() ?? "N/A")} រៀល",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          /* Text(
                                            overflow: TextOverflow.ellipsis,
                                            " ${ userTripInfoDetail?["cost"].toString() ?? "N/A" } រៀល",
                                            style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold
                                            ),
                                          ),*/
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.person, color: ColorResources.primaryColor),
                                SizedBox(width: 20),
                                Text("ឈ្មោះអ្នកដំណើរ: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(userTripInfoDetail?["passenger_name"] ?? "N/A",
                                  style: TextStyle(
                                    color: ColorResources.blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.phone, color: ColorResources.primaryColor),
                                SizedBox(width: 20),
                                Text("លេខទូរស័ព្ទ: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  formattedPhoneNumber,
                                  style: TextStyle(
                                    color: ColorResources.blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.location,color: ColorResources.primaryColor),
                                SizedBox(width: 20),
                                Text("ចម្ងាយទីតាំង: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  formattedDistance,
                                  style: TextStyle(
                                    color: ColorResources.blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          ),
                          //Todo: start button and call
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Stack(
                                    children: [
                                      IconButton(
                                        //onPressed: callNumber,
                                        onPressed: (){},
                                        icon: Icon(
                                            CupertinoIcons.phone_fill,
                                            color: Colors.white
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Stack(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          //nextScreen(context, MessageScreen());
                                        },
                                        icon: Icon(
                                            CupertinoIcons
                                                .chat_bubble_fill,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16),
                                SizedBox(
                                  width: Get.width /2,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[400],
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    ),
                                    onPressed: () {
                                      nextScreen(context, DriverPickPassengerScreen());
                                    },
                                    child: Text(
                                      "ចាប់ផ្តើមការដឹកជញ្ជូន",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("បញ្ជាក់"),
          content: Text("តេីអ្នកពិតជាចង់លុបចោលការកក់មែនទេ?",style: TextStyle(color:ColorResources.blackColor , fontSize: 16),),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorResources.greyColor
              ),
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text('បោះបង់',style: TextStyle(color:ColorResources.blackColor , fontSize: 14),),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorResources.redColor
              ),
              onPressed: (){
                nextScreen(context, AppScreen());
              },
              child: Text('យល់ព្រម',style: TextStyle(color:ColorResources.whiteColor , fontSize: 14),),
            ),
          ],
        );
      },
    );
  }
}
