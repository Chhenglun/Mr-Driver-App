// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:scholarar/view/custom/custom_show_snakbar.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

  Future<bool> get isConnected async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static checkConnectivity(context) async {
    bool firstTime = true;
    late bool isNotConnected;
    isNotConnected = false;

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      isNotConnected = false;
      if (!firstTime) {
        if (result == ConnectivityResult.none) {
          isNotConnected = true;
        } else {
          isNotConnected = !await _updateConnectivityStatus();
        }
        isNotConnected ? SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        customShowSnackBar(isNotConnected ? "No Connection" : "Connected", context, isError: isNotConnected ? true : false);
      }
      firstTime = false;
    });
    return isNotConnected;
  }

  static Future<bool> _updateConnectivityStatus() async {
    bool? isConnected;
    try {
      final List<InternetAddress> result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } catch (e) {
      isConnected = false;
    }
    return isConnected!;
  }
}
