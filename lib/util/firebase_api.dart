// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scholarar/util/app_constants.dart';
import '../view/app/app_screen.dart';
import 'next_screen.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseAPI {

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if(message != null) {
      return;
    }

    nextScreen(Get.context!, AppScreen());
  }

  Future initPushNotification() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if(notification == null) return;
      notificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id,
                  _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: '@drawable/ic_launcher'
              )
          ),
          payload: jsonEncode(message.toMap())
      );
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    frmTokenPublic = fcmToken;
    print('fcmToken: $fcmToken');
  }
}