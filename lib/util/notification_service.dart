
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

int id = 0;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function


final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();

const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  '0', // id
  'My Channel', // title
  importance: Importance.high,
);

class Notifications {
  static Future init() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
  }

  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(id++, 'plain title', 'plain body', notificationDetails, payload: 'item x');
  }
}

