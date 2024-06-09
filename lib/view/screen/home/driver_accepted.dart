import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DriverAccepted extends StatefulWidget {
  const DriverAccepted({super.key});

  @override
  State<DriverAccepted> createState() => _DriverAcceptedState();
}

class _DriverAcceptedState extends State<DriverAccepted> {
  bool isLoading = false;
  late GoogleMapController googleMapController;
  final TextEditingController _searchController = TextEditingController();

  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(11.672144885466007, 105.0565917044878), zoom: 15);

  Set<Marker> markers = {};
  LatLng selectedLatLng = LatLng(0, 0);
  String selectedAddress = '';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    markers.clear();
    markers.add(
        Marker(markerId: MarkerId('currentLocation'), position: currentLatLng));

    googleMapController.animateCamera(CameraUpdate.newLatLng(currentLatLng));

    setState(() {
      selectedLatLng = currentLatLng;
      getAddressFromLatLng(currentLatLng);
    });
  }

  void getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark place = placemarks[0];
    setState(() {
      selectedAddress =
          "${place.name}, ${place.thoroughfare}, ${place.subLocality}, ${place.locality}";
    });
  }

  before() async {
    await _getGeoLocationPosition();
    await getCurrentLocation();
    setState(() {
      latCur = selectedLatLng.latitude;
      longCur = selectedLatLng.longitude;
      print(latCur);
      print(longCur);
    });
  }

  @override
  void initState() {
    before();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: initialCameraPosition,
                          markers: markers,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          onMapCreated: (GoogleMapController controller) {
                            googleMapController = controller;
                          },
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Column(
                            children: [
                              Container(
                                child: ElevatedButton(
                                    style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.red),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Row(
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
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isLoading == true)
              Container(
                color: Colors.white.withOpacity(0.8),
                child: Center(
                  child: Text('Loading...'),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                            height: MediaQuery.sizeOf(context).height * 3 /  10,
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
                                      Text('អ្នកបើកបរនឹងមកដល់កំឡុងពេល ១៥​ នាទីទៀត'),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                      child: Container(
                                        width: MediaQuery.sizeOf(context).width * 1 / 5,
                                        height: MediaQuery.sizeOf(context).height * 1 / 10,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider('https://th.bing.com/th/id/OIP.OgRB0U7cw81ZoY9UyZVWvAHaHa?rs=1&pid=ImgDetMain'), fit: BoxFit.cover,
                                          )
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text('NARAK RK', style: TextStyle(fontWeight: FontWeight.bold),),
                                            SizedBox(width: 25,),
                                            Icon(Icons.call),
                                            SizedBox(width: 10,),
                                            Icon(Icons.chat_bubble_outline),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('កំពុងធ្វើដំណើរ ៤ គីឡូមែត្រ . . .'),
                                            Icon(Icons.location_on, color: Colors.red,)
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('តម្លៃ ៩៩០០ រ', style: TextStyle(fontSize: 17),),
                                      Icon(Icons.qr_code_scanner)
                                    ],
                                  ),
                                ),
                              //   Padding(
                              //     padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Icon(Icons.call),
                              //         Icon(Icons.chat_bubble_outline),
                              //         Container(
                              //   child: ElevatedButton(
                              //       style: const ButtonStyle(
                              //         backgroundColor:
                              //             MaterialStatePropertyAll(Colors.red),
                              //       ),
                              //       onPressed: () {
                              //         Navigator.pop(context);
                              //       },
                              //       child: Text(
                              //         'លុបចោលការកក់',
                              //         style: TextStyle(color: Colors.white),
                              //       )),
                              // ),
                              
                              //       ],
                              //     ),
                              //   )
                              ],
                            )
                          ),
              ),
            ],
          ),
        ),
        );
  }
}
