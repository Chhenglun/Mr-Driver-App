import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';

import '../../../util/color_resources.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, dynamic>? storedTripData;
  bool isLoading = true;
  bool _showDetails = false;

  String? startLocationAddress;
  String? endLocationAddress;
  String? driverLocationAddress;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('getDriverTrip');

    if (storedData != null) {
      setState(() {
        storedTripData = json.decode(storedData);
      });
      await _getAddresses();
      setState(() {
        isLoading = false;
      });
      print('Stored Trip Data: $storedTripData');
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getAddresses() async {
    if (storedTripData != null) {
      List<dynamic> startCoordinates = storedTripData!['start_location']['coordinates'];
      List<dynamic> endCoordinates = storedTripData!['end_location']['coordinates'];
      List<dynamic> driverCoordinates = storedTripData!['driver_location']['coordinates'];

      startLocationAddress = await _getAddressFromCoordinates(startCoordinates[1], startCoordinates[0]);
      endLocationAddress = await _getAddressFromCoordinates(endCoordinates[1], endCoordinates[0]);
      driverLocationAddress = await _getAddressFromCoordinates(driverCoordinates[1], driverCoordinates[0]);

      setState(() {});
    }
  }

  Future<String> _getAddressFromCoordinates(double latitude, double longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      return '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
    }
    return 'Unknown location';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorResources.primaryColor,
        leading: IconButton(onPressed: (){{
          Navigator.pop(context);
        }
        }, icon: Icon(Icons.arrow_back_ios,color: ColorResources.whiteColor,)),
        title: Text(
          'ប្រវត្តិរបស់អ្នក',
          style: TextStyle(
            fontSize: 22,
            color: ColorResources.whiteColor,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : storedTripData != null
              ? SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Colors.teal,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Booking Info:',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                _buildSummaryInfo(),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _showDetails = !_showDetails;
                                    });
                                  },
                                  child: Text(
                                    _showDetails ? 'Hide Details' : 'See Details',
                                    style: TextStyle(color: Colors.teal),
                                  ),
                                ),
                                Visibility(
                                  visible: _showDetails,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: _buildDetailInfo(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
              : Center(child: Text('មិនមានប្រវត្តិ...',style: TextStyle(fontSize: 16),)),
    );
  }

  Widget _buildSummaryInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoRow('Booking ID', storedTripData!['_id']),
            _buildInfoRow('Status', storedTripData!['status']),
            
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Booking Date:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              storedTripData!['createdAt'],
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        )
        //_buildInfoRow('Updated At', storedTripData!['updatedAt']),
      ],
    );
  }

  List<Widget> _buildDetailInfo() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoRow('Passenger Name', storedTripData!['passenger_name']),
          _buildInfoRow('Passenger Phone', storedTripData!['passenger_phone_number']),
        ],
      ),
      _buildInfoRow('Start Location', startLocationAddress),
      _buildInfoRow('End Location', endLocationAddress),
      //_buildInfoRow('Driver Location', driverLocationAddress),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoRow('Driver Name', '${storedTripData!['driver_id']['first_name']} ${storedTripData!['driver_id']['last_name']}'),
          Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(
                  Icons.payments_outlined,
                  color: Colors.teal,
                ),
                SizedBox(width: 10),
                Text(
                  'Paid',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Text(
              '\$ ${ storedTripData!['cost']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    ),
        ],
      ),
    ];
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              value != null ? value.toString() : 'N/A',
              style: TextStyle(
                color: value == "accepted" ? Colors.green : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
