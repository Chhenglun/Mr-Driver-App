import 'dart:async';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../../../controller/booking_process_controller.dart';
import '../../../util/app_constants.dart';
import '../../../util/color_resources.dart';
import '../../../util/firebase_api.dart';
import '../../../util/next_screen.dart';
import 'driver_start_pick_passenger_screen.dart';

class DriverPickPassenger extends StatefulWidget {
  const DriverPickPassenger({super.key});

  @override
  State<DriverPickPassenger> createState() => _DriverPickPassengerState();
}

class _DriverPickPassengerState extends State<DriverPickPassenger> {
  final BookingProcessController bookingController =
      Get.find<BookingProcessController>();
  final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polyLineCoordinatesDriverToPassenger = [];
  LatLng currentPosition = LatLng(0, 0);
  late LatLng driverPosition; //= LatLng(0, 0);
  late LatLng passengerPosition; //= LatLng(0, 0);
  LatLng endPosition = LatLng(0, 0);
  StreamSubscription<Position>? positionStreamSubscription;
  String url =
      "https://toppng.com/uploads/preview/user-account-management-logo-user-icon-11562867145a56rus2zwu.png";
  Timer? driverTimer;
  bool isLoading = true;
  BitmapDescriptor driverIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor passengerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor endIcon = BitmapDescriptor.defaultMarker;
  final FirebaseAPI _firebaseAPI = FirebaseAPI();
  String? _tripID;
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
      setLocations();
      getPolyPoints();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setLocations();
    _configureFirebaseListeners();
    setDriverIcon();
    setPassengerIcon();
    setEndIcon();
    _checkLocationPermissions();
    if (bookingController.tripID != null) {
      init();
    }
  }

  void _configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage received');
      if (message.data.containsKey('tripId')) {
        setState(() {
          _tripID = message.data['tripId'];
        });
        print('Received tripID: $_tripID');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp received');
      if (message.data.containsKey('tripId')) {
        setState(() {
          _tripID = message.data['tripId'];
        });
        print('Received tripID: $_tripID');
      }
    });
  }

  Future<void> setLocations() async {
    var userTripInfoDetail = bookingController.tripInfo;
    if (userTripInfoDetail != null) {
      if (userTripInfoDetail["start_location"] != null) {
        var passengerCoordinates =
            userTripInfoDetail["start_location"]["coordinates"];
        setState(() {
          passengerPosition =
              LatLng(passengerCoordinates[1], passengerCoordinates[0]);
        });
        print("Passenger position set to: $passengerPosition");
      }
      if (userTripInfoDetail["driver_location"] != null) {
        var driverCoordinates =
            userTripInfoDetail["driver_location"]["coordinates"];
        setState(() {
          driverPosition = LatLng(driverCoordinates[1], driverCoordinates[0]);
          currentPosition = driverPosition;
        });
        print("Driver position set to: $driverPosition");
      }
      if (userTripInfoDetail["end_location"] != null) {
        var endCoordinates = userTripInfoDetail["end_location"]["coordinates"];
        setState(() {
          endPosition = LatLng(endCoordinates[1], endCoordinates[0]);
        });
        print("End position set to: $endPosition");
      }
    }
  }

  Set<Marker> _markers() {
    var userTripInfoDetail = bookingController.tripInfo;

    LatLng driverLatLng;
    LatLng passengerLatLng;
    LatLng endLatLng;

    if (userTripInfoDetail != null) {
      if (userTripInfoDetail["driver_location"]["coordinates"] != null) {
        driverLatLng = LatLng(
            userTripInfoDetail["driver_location"]["coordinates"][1],
            userTripInfoDetail["driver_location"]["coordinates"][0]);
      } else {
        driverLatLng = LatLng(0, 0);
      }

      if (userTripInfoDetail["start_location"]["coordinates"] != null) {
        passengerLatLng = LatLng(
            userTripInfoDetail["start_location"]["coordinates"][1],
            userTripInfoDetail["start_location"]["coordinates"][0]);
      } else {
        passengerLatLng = LatLng(0, 0);
      }

      if (userTripInfoDetail["end_location"]["coordinates"] != null) {
        endLatLng = LatLng(userTripInfoDetail["end_location"]["coordinates"][1],
            userTripInfoDetail["end_location"]["coordinates"][0]);
      } else {
        endLatLng = LatLng(0, 0);
      }
    } else {
      driverLatLng = LatLng(0, 0);
      passengerLatLng = LatLng(0, 0);
      endLatLng = LatLng(0, 0);
    }

    return <Marker>[
      Marker(
        markerId: MarkerId('driver_location'),
        position: driverLatLng,
        icon: driverIcon,
      ),
      Marker(
        markerId: MarkerId('passenger_location'),
        position: passengerLatLng,
        icon: passengerIcon,
      ),
      Marker(
        markerId: MarkerId('end_location'),
        position: endLatLng,
        icon: endIcon,
      ),
    ].toSet();
  }

  Future<void> setDriverIcon() async {
    final ByteData byteData =
        await rootBundle.load('assets/icons/driver_icon.jpg');
    final img.Image? image = img.decodeImage(byteData.buffer.asUint8List());

    final img.Image resizedImage =
        img.copyResize(image!, width: 120, height: 120);

    final ui.Codec codec = await ui.instantiateImageCodec(
      img.encodePng(resizedImage).buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    final ByteData? resizedByteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? resizedUint8List = resizedByteData?.buffer.asUint8List();

    final BitmapDescriptor driverIcon =
        await BitmapDescriptor.fromBytes(resizedUint8List!);
    setState(() {
      this.driverIcon = driverIcon;
      print("Driver icon set");
    });
  }

  Future<void> setPassengerIcon() async {
    final ByteData byteData =
        await rootBundle.load('assets/icons/user_icon.jpg');
    final img.Image? image = img.decodeImage(byteData.buffer.asUint8List());

    final img.Image resizedImage =
        img.copyResize(image!, width: 100, height: 150);

    final ui.Codec codec = await ui.instantiateImageCodec(
      img.encodePng(resizedImage).buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    final ByteData? resizedByteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? resizedUint8List = resizedByteData?.buffer.asUint8List();

    final BitmapDescriptor passengerIcon =
        await BitmapDescriptor.fromBytes(resizedUint8List!);
    setState(() {
      this.passengerIcon = passengerIcon;
      print("Passenger icon set");
    });
  }

  Future<void> setEndIcon() async {
    final ByteData byteData =
        await rootBundle.load('assets/icons/driver_pin_map.jpg');
    final img.Image? image = img.decodeImage(byteData.buffer.asUint8List());

    final img.Image resizedImage =
        img.copyResize(image!, width: 100, height: 150);

    final ui.Codec codec = await ui.instantiateImageCodec(
      img.encodePng(resizedImage).buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    final ByteData? resizedByteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? resizedUint8List = resizedByteData?.buffer.asUint8List();

    final BitmapDescriptor endIcon =
        await BitmapDescriptor.fromBytes(resizedUint8List!);
    setState(() {
      this.endIcon = endIcon;
      print("End icon set");
    });
  }

  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    driverTimer?.cancel();
    super.dispose();
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult resultDriverToPassenger =
        await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: AppConstants.google_key_api,
      request: PolylineRequest(
          origin:
              PointLatLng(driverPosition.latitude, driverPosition.longitude),
          destination: PointLatLng(
              passengerPosition.latitude, passengerPosition.longitude),
          mode: TravelMode.driving),
    );

    if (resultDriverToPassenger.points.isNotEmpty) {
      polyLineCoordinatesDriverToPassenger.clear();
      resultDriverToPassenger.points.forEach((PointLatLng point) {
        polyLineCoordinatesDriverToPassenger
            .add(LatLng(point.latitude, point.longitude));
      });
      print("Polyline from driver to passenger set");
    } else {
      print("No points found for driver to passenger");
    }

    setState(() {
      print("Polyline coordinates updated");
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
    listenToPositionStream();
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      driverPosition = currentPosition;
      getPolyPoints();
      _simulateDriverMovement();
    });
  }

  void listenToPositionStream() {
    positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position newPosition) {
      print(
          '=====>>>>>>New position obtained: ${newPosition.latitude}, ${newPosition.longitude}');
      setState(() {
        currentPosition = LatLng(newPosition.latitude, newPosition.longitude);
        driverPosition = currentPosition;
        _animateCameraToPosition(newPosition);
        getPolyPoints();
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
        getPolyPoints();
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
                double? distance = userTripInfoDetail?[
                    "distance_between_passenger_and_driver"];
                String formattedDistance = distance != null
                    ? "${distance.toStringAsFixed(2)} km"
                    : "N/A";
                String? phoneNumber =
                    userTripInfoDetail?["passenger_phone_number"];
                String formattedPhoneNumber = phoneNumber != null
                    ? formatPhoneNumber(phoneNumber)
                    : "N/A";
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
                          polylineId: PolylineId("routeDriverToPassenger"),
                          points: polyLineCoordinatesDriverToPassenger,
                          color: Colors.blue,
                          width: 6,
                        ),
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
                              height:
                                  MediaQuery.of(context).size.height * 3 / 8,
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
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 20),
                                      child: Text(
                                        "សូមចុចប៉ូតុងខាងក្រោមពេលអ្នកទៅដល់ទីតាំងអ្នកកក់",
                                        style: TextStyle(
                                          color: ColorResources.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Divider(thickness: 2),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundImage:
                                                    NetworkImage(url),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 15),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300]),
                                            onPressed: () {},
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 25),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text("តម្លៃការដឹកជញ្ជូន: ",
                                                      style: TextStyle(
                                                          color: ColorResources
                                                              .blackColor,
                                                          fontSize: 14)),
                                                  Text(
                                                    "${(userTripInfoDetail?["cost"]?.toDouble()?.toInt().toString() ?? "N/A")} រៀល",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        children: [
                                          Icon(CupertinoIcons.person,
                                              color:
                                                  ColorResources.primaryColor),
                                          SizedBox(width: 20),
                                          Text(
                                            "ឈ្មោះអ្នកដំណើរ: ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            userTripInfoDetail?[
                                                    "passenger_name"] ??
                                                "N/A",
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        children: [
                                          Icon(CupertinoIcons.phone,
                                              color:
                                                  ColorResources.primaryColor),
                                          SizedBox(width: 20),
                                          Text(
                                            "លេខទូរស័ព្ទ: ",
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        children: [
                                          Icon(CupertinoIcons.location,
                                              color:
                                                  ColorResources.primaryColor),
                                          SizedBox(width: 20),
                                          Text(
                                            "ចម្ងាយពីអ្នក - អ្នកកក់: ",
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
                                                  onPressed: () {},
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
                                                    CupertinoIcons
                                                        .chat_bubble_fill,
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
                                                backgroundColor:
                                                    Colors.red[400],
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 10),
                                              ),
                                              onPressed: () {
                                                nextScreenNoReturn(context,
                                                    DriverStartPickPasssenger());
                                              },
                                              child: Text(
                                                "បានមកដល់ទីតាំងអ្នកកក់",
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
