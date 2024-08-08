// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:capstone_project2/theme/dark_theme.dart';
import 'package:capstone_project2/theme/light_theme.dart';
import 'package:capstone_project2/util/alert_dialog.dart';
import 'package:capstone_project2/util/app_constants.dart';
import 'package:capstone_project2/util/firebase_api.dart';
import 'package:capstone_project2/util/messages.dart';
import 'package:capstone_project2/util/notification_service.dart';
import 'package:capstone_project2/view/screen/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'controller/localization_controller.dart';
import 'controller/theme_controller.dart';
import 'helper/get_di.dart' as di;

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await di.init();

  if (Platform.isAndroid) {
    await FirebaseAPI().initNotifications();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HttpOverrides.global = MyHttpOverrides();

  Map<String, Map<String, String>> _languages = await di.init();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(MyApp(languages: _languages));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({Key? key, required this.languages}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      firebaseInit();
    }
  }

  Future<void> firebaseInit() async {
    WidgetsBinding.instance.addObserver(this);
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        FlutterAppBadger.updateBadgeCount(1);
        customNotificationDialog(
          context: context,
          title: message.notification!.title!,
          body: message.notification!.body!,
          onTap: () {
            FlutterAppBadger.removeBadge();
            //nextScreen(context, AcceptedScreen());
          },
        );
      }
    });

    Notifications.init();

    if (Platform.isAndroid) {
      await Permission.notification.request();
    }

    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    String? token = await _firebaseMessage.getToken();
    if (token != null) {
      print('FCM Token: $token');
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
          supportedLocales: AppConstants.languages
              .map((language) => Locale(language.languageCode!, language.countryCode))
              .toList(),
          localeListResolutionCallback: (locales, supportedLocales) {
            for (var locale in locales!) {
              if (supportedLocales.contains(locale)) {
                return locale;
              }
            }
            return supportedLocales.first;
          },
          fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
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
