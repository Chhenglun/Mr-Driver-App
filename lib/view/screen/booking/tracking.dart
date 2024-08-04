import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarar/controller/get_booking_request.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/color_resources.dart';
import 'package:scholarar/util/next_screen.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:scholarar/view/screen/booking/arrive_location.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  GetBookingRequestController bookingController = Get.find<GetBookingRequestController>();
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng destination = LatLng(11.544, 104.8112);
  List<LatLng> polyLineCoordinates = [];
  LatLng currentPosition = destination;
  LatLng driverPosition = LatLng(11.570, 104.875);
  LatLng passengerPosition = destination; // Add passenger position
  StreamSubscription<Position>? positionStreamSubscription;
  String url = "https://toppng.com/uploads/preview/user-account-management-logo-user-icon-11562867145a56rus2zwu.png";
  Timer? driverTimer;
  bool isLoading = true;
  BitmapDescriptor CurrentIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor DestinationIcon = BitmapDescriptor.defaultMarker;

  Future<void> init() async {
    //tripInfo
    await bookingController.getTripInfo(bookingController.tripID);
    setPassengerPosition();
    setState(() {
      isLoading = false;
    });
  }

  void setPassengerPosition() {
    var userTripInfoDetail = bookingController.tripInfo;
    if (userTripInfoDetail != null && userTripInfoDetail["start_location"] != null) {
      var coordinates = userTripInfoDetail["start_location"]["coordinates"];
      setState(() {
        passengerPosition = LatLng(coordinates[1], coordinates[0]);
      });
    }
  }

  @override
  void initState() {
    setState(() {
      init();
      _checkLocationPermissions();
    });
    setCurrentIcon();
    setDestinationIcon();
    super.initState();
  }

  Set<Marker> _markers() {
    return <Marker>[
      Marker(
        markerId: MarkerId('current_location'),
        position: currentPosition,
        icon: CurrentIcon!,
      ),
      Marker(
        markerId: MarkerId('passenger_location'),
        position: passengerPosition,
        icon: DestinationIcon!,
      ),
    ].toSet();
  }

  void setCurrentIcon() async {
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

    final BitmapDescriptor Currenticon = await BitmapDescriptor.fromBytes(resizedUint8List!);
    setState(() {
      CurrentIcon = Currenticon;
    });
  }

  void setDestinationIcon() async {
    final ByteData byteData = await rootBundle.load('assets/icons/user_icon.jpg');
    final img.Image? image = img.decodeImage(byteData.buffer.asUint8List());

    // Resize the image
    final img.Image resizedImage = img.copyResize(image!, width: 100, height: 150);

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
      destination: PointLatLng(passengerPosition.latitude, passengerPosition.longitude),
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
    var userTripInfoDetail = bookingController.tripInfo;
    print("UserTripInfoDetail : $userTripInfoDetail");
    return Scaffold(
      body: isLoading
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
              )
            },
            markers: _markers(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*Container(
                color: Colors.blue,
                width: MediaQuery.of(context).size.width / 2.5,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
              ),*/
              Spacer(),
              Visibility(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.sizeOf(context).height * 3 / 8,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20, top: 20),
                                child: Text(
                                  "ព័ត៌មានលំអិតរបស់អ្នកដំណើរ",
                                  style: TextStyle(
                                      color: ColorResources.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(thickness: 2),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 5, left: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(url),
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[300]),
                                        onPressed: () {},
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 50),
                                          child: Text(
                                            "12000រៀល",
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 20),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.person, color: Colors.black),
                                    SizedBox(width: 20),
                                    Text(
                                      userTripInfoDetail?["passenger_id"]
                                      ["first_name"] +
                                          " " +
                                          userTripInfoDetail?["passenger_id"]
                                          ["last_name"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.phone, color: Colors.black),
                                    SizedBox(width: 20),
                                    Text(
                                      userTripInfoDetail?["passenger_id"]
                                      ["phone_number"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.person_2,color: Colors.black),
                                    SizedBox(width: 20),
                                    Text(
                                      userTripInfoDetail?["passenger_id"]
                                      ["gender"] ??
                                          "N/A",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[500]),
                                    onPressed: () {
                                      nextScreen(context, ArriveScreen());
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        "បានមកដល់ទីតាំង",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
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
        ],
      ),
    );
  }
}
