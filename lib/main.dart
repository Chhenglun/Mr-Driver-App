
// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scholarar/controller/localization_controller.dart';
import 'package:scholarar/controller/theme_controller.dart';
import 'package:scholarar/theme/dark_theme.dart';
import 'package:scholarar/theme/light_theme.dart';
import 'package:scholarar/util/alert_dialog.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/firebase_api.dart';
import 'package:scholarar/util/messages.dart';
import 'package:scholarar/util/notification_service.dart';
import 'package:scholarar/view/screen/splash/splash_screen.dart';

import 'helper/get_di.dart' as di;

late List<CameraDescription> cameras;
Future<void> main(context) async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid) {
    await Firebase.initializeApp();
    await Future.delayed(Duration(seconds: 1));
    await FirebaseAPI().initNotifications();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await di.init();
  HttpOverrides.global = MyHttpOverrides();
  Map<String, Map<String, String>> _languages = await di.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark)
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
  runApp(MyApp(languages: _languages));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key, required this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  firebase() async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.getToken();
    await FirebaseMessaging.instance.onTokenRefresh;
    String? fcmtoken = await FirebaseMessaging.instance.getAPNSToken();

    await FirebaseAPI().initNotifications();
    if(Platform.isAndroid){
      Permission.notification.request();
    }
    await FirebaseMessaging.instance.getAPNSToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('onMessages: ${message.notification!.title!}');
    });
    if(fcmtoken != null) {
      print('fcmtoken $fcmtoken');
    }
    await FirebaseAPI().initNotifications();
  }
  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid) {
      firebase();
      WidgetsBinding.instance.addObserver(this);
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          print('message $message');
        }
      });
      if(Platform.isAndroid){
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          FlutterAppBadger.updateBadgeCount(1);
          Future.delayed(Duration(seconds: 1), () {
            customNotificationDialog(
              context: Get.context!,
              title: message.notification!.title!,
              username: message.notification!.body!,
              onTap: () {
                Get.back();
                FlutterAppBadger.removeBadge();
              },
              //btnText: 'ok'.tr,
            );
          });
        });
      }
      Notifications.init();
      if(Platform.isAndroid){
        Permission.notification.request();
      }
      FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
      _firebaseMessage.getToken().then((token) =>{
        print('token $token')
      });
    }
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetMaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: themeController.darkTheme ? dark : light,
          translations: Messages(languages: widget.languages),
          locale: localizeController.locale,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale(AppConstants.languages[0].languageCode!,
                AppConstants.languages[0].countryCode),
            Locale(AppConstants.languages[1].languageCode!,
                AppConstants.languages[1].countryCode),
            Locale(AppConstants.languages[2].languageCode!,
                AppConstants.languages[2].countryCode),
          ],
          localeListResolutionCallback: (locales, supportedLocales) {
            for (var locale in locales!) {
              if (supportedLocales.contains(locale)) {
                return locale;
              }
            }
            return supportedLocales.first;
          },
          fallbackLocale: Locale(AppConstants.languages[0].languageCode!,AppConstants.languages[0].countryCode),
          home: SplashScreen(),
        );
      });
    });
  }
}


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
