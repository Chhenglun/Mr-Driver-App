import 'dart:async';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:flutter_polyline_points/src/point_lat_lng.dart';
import 'package:flutter_polyline_points/src/utils/request_enums.dart';
import 'package:flutter_polyline_points/src/utils/polyline_request.dart';
import 'package:flutter_polyline_points/src/utils/polyline_result.dart';

import '../../../controller/booking_process_controller.dart';
import '../../../util/app_constants.dart';
import '../../../util/color_resources.dart';
import '../../../util/firebase_api.dart';

class DriverStartPickPasssenger extends StatefulWidget {
  const DriverStartPickPasssenger({super.key});

  @override
  State<DriverStartPickPasssenger> createState() => _DriverStartPickPasssengerState();
}

class _DriverStartPickPasssengerState extends State<DriverStartPickPasssenger> {
  final BookingProcessController bookingController = Get.find<BookingProcessController>();
  final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polyLineCoordinates = [];
  LatLng currentPosition = const LatLng(0, 0);
  LatLng driverPosition = const LatLng(0, 0);
  LatLng passengerPosition = const LatLng(0, 0);
  LatLng endPosition = const LatLng(0, 0); // Added for end location
  StreamSubscription<Position>? positionStreamSubscription;
  String url = "https://toppng.com/uploads/preview/user-account-management-logo-user-icon-11562867145a56rus2zwu.png";
  Timer? driverTimer;
  bool isLoading = true;
  BitmapDescriptor driverIcon = BitmapDescriptor.defaultMarker; // Updated icon name
  BitmapDescriptor passengerIcon = BitmapDescriptor.defaultMarker; // Added for passenger icon
  BitmapDescriptor endIcon = BitmapDescriptor.defaultMarker; // Added for end location icon
  final FirebaseAPI _firebaseAPI = FirebaseAPI();
  String? _tripID; // To store the tripID
  bool isDialogVisible = false;

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return "(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6, 10)}";
    } else {
      return phoneNumber;
    }
  }

  Future<void> init() async {
    if (_tripID != null) {
      await bookingController.getTripInfo(bookingController.tripID);
      print("Trip Info: ${bookingController.tripInfo}");
      setLocations(); // Updated to set all locations
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _configureFirebaseListeners();
    setDriverIcon();
    setPassengerIcon();
    setEndIcon();
    _checkLocationPermissions();
    if (bookingController.tripID != null) {
      init();
    }
  }

  //getTripID
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
          //_showCustomNotificationDialog(context, message.data['title'], message.data['body']);
        }
      }
    });
  }

  void setLocations() {
    var userTripInfoDetail = bookingController.tripInfo;
    if (userTripInfoDetail != null) {
      if (userTripInfoDetail["start_location"] != null) {
        var passengerCoordinates = userTripInfoDetail["start_location"]["coordinates"];
        setState(() {
          passengerPosition = LatLng(passengerCoordinates[1], passengerCoordinates[0]);
        });
        print("Passenger position set to: $passengerPosition");
      }
      if (userTripInfoDetail["driver_location"] != null) {
        var driverCoordinates = userTripInfoDetail["driver_location"]["coordinates"];
        setState(() {
          driverPosition = LatLng(driverCoordinates[1], driverCoordinates[0]);
          currentPosition = driverPosition; // Set driver's current location
        });
        print("Driver position set to: $driverPosition");
      }
      if (userTripInfoDetail["end_location"] != null) { // Added for end location
        var endCoordinates = userTripInfoDetail["end_location"]["coordinates"];
        setState(() {
          endPosition = LatLng(endCoordinates[1], endCoordinates[0]);
        });
        print("End position set to: $endPosition");
      }
    }
  }

  Set<Marker> _markers() {
    return <Marker>[
      Marker(
        markerId: MarkerId('driver_location'),
        position: driverPosition,
        icon: driverIcon, // Changed icon
      ),
      Marker(
        markerId: MarkerId('passenger_location'),
        position: passengerPosition,
        icon: passengerIcon, // Changed icon
      ),
      Marker(
        markerId: MarkerId('end_location'),
        position: endPosition,
        icon: endIcon, // Added marker for end location
      ),
    ].toSet();
  }

  Future<void> setDriverIcon() async { // Renamed for clarity
    final ByteData byteData = await rootBundle.load('/mnt/data/driver_icon.jpg');
    final img.Image? image = img.decodeImage(byteData.buffer.asUint8List());

    final img.Image resizedImage = img.copyResize(image!, width: 120, height: 120);

    final ui.Codec codec = await ui.instantiateImageCodec(
      img.encodePng(resizedImage).buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    final ByteData? resizedByteData = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? resizedUint8List = resizedByteData?.buffer.asUint8List();

    final BitmapDescriptor driverIcon = await BitmapDescriptor.fromBytes(resizedUint8List!);
    setState(() {
      this.driverIcon = driverIcon;
    });
  }

  Future<void> setPassengerIcon() async { // Added method for passenger icon
    final ByteData byteData = await rootBundle.load('/mnt/data/user_icon.jpg');
    final img.Image? image = img.decodeImage(byteData.buffer.asUint8List());

    final img.Image resizedImage = img.copyResize(image!, width: 100, height: 150);

    final ui.Codec codec = await ui.instantiateImageCodec(
      img.encodePng(resizedImage).buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    final ByteData? resizedByteData = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? resizedUint8List = resizedByteData?.buffer.asUint8List();

    final BitmapDescriptor passengerIcon = await BitmapDescriptor.fromBytes(resizedUint8List!);
    setState(() {
      this.passengerIcon = passengerIcon;
    });
  }

  Future<void> setEndIcon() async { // Added method for end location icon
    final ByteData byteData = await rootBundle.load('/mnt/data/driver_pin_map.jpg');
    final img.Image? image = img.decodeImage(byteData.buffer.asUint8List());

    final img.Image resizedImage = img.copyResize(image!, width: 100, height: 150);

    final ui.Codec codec = await ui.instantiateImageCodec(
      img.encodePng(resizedImage).buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    final ByteData? resizedByteData = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? resizedUint8List = resizedByteData?.buffer.asUint8List();

    final BitmapDescriptor endIcon = await BitmapDescriptor.fromBytes(resizedUint8List!);
    setState(() {
      this.endIcon = endIcon;
    });
  }

  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    driverTimer?.cancel();
    super.dispose();
  }

  void getPolyPoint() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineRequest request = PolylineRequest(
      origin: PointLatLng(driverPosition.latitude, driverPosition.longitude),
      destination: PointLatLng(endPosition.latitude, endPosition.longitude), // Changed to endPosition
      mode: TravelMode.driving,
    );

    try {
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
    listenToPositionStream();
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      driverPosition = currentPosition; // Set driver's current location
      getPolyPoint();
      _simulateDriverMovement();
    });
  }

  void listenToPositionStream() {
    positionStreamSubscription = Geolocator.getPositionStream().listen((Position newPosition) {
      print('=====>>>>>>New position obtained: ${newPosition.latitude}, ${newPosition.longitude}');
      setState(() {
        currentPosition = LatLng(newPosition.latitude, newPosition.longitude);
        driverPosition = currentPosition; // Update driver's current location
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
      body: bookingController.isLoading
          ? Center(child: CircularProgressIndicator())
          : Builder(
        builder: (context) {
          var userTripInfoDetail = bookingController.tripInfo;
          print("UserTripInfoDetail : $userTripInfoDetail");
          double? distance = userTripInfoDetail?["distance_between_passenger_and_driver"];
          String formattedDistance = distance != null ? "${distance.toStringAsFixed(2)} km" : "N/A";

          String? phoneNumber = userTripInfoDetail?["passenger_phone_number"];
          String formattedPhoneNumber = phoneNumber != null ? formatPhoneNumber(phoneNumber) : "N/A";

          return Stack(
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
                  )
                },
                markers: _markers(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 3 / 8,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20, top: 20),
                                child: Text(
                                  "សូមស្វាគមន៍មកកាន់ការដឹកជញ្ជូន",
                                  style: TextStyle(
                                    color: ColorResources.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Divider(thickness: 2),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(url),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 15),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                                      onPressed: () {},
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("តម្លៃការដឹកជញ្ជូន: ", style: TextStyle(color: ColorResources.blackColor, fontSize: 14)),
                                            Text(
                                              "${(userTripInfoDetail?["cost"]?.toDouble()?.toInt().toString() ?? "N/A")} រៀល",
                                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
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
                                    Icon(CupertinoIcons.location, color: ColorResources.primaryColor),
                                    SizedBox(width: 20),
                                    Text("ចម្ងាយពីអ្នក - អ្នកកក់: ",
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
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                                            onPressed: (){},
                                            icon: Icon(
                                              CupertinoIcons.phone_fill,
                                              color: Colors.white,
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
                                            onPressed: () {},
                                            icon: Icon(
                                              CupertinoIcons.chat_bubble_fill,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    SizedBox(
                                      width: Get.width / 2,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[400],
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        ),
                                        onPressed: () {
                                          bookingController.startTrip(tripId: bookingController.tripID);
                                        },
                                        child: Text(
                                          "ចាប់ផ្តើមការដឹក",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
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
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
