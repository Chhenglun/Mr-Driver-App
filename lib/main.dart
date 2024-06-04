
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:scholarar/controller/localization_controller.dart';
import 'package:scholarar/controller/theme_controller.dart';
import 'package:scholarar/theme/dark_theme.dart';
import 'package:scholarar/theme/light_theme.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:scholarar/util/messages.dart';
import 'package:scholarar/view/screen/splash/splash_screen.dart';

import 'helper/get_di.dart' as di;

late List<CameraDescription> cameras;
Future<void> main(context) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  cameras = await availableCameras();
  await di.init();
  HttpOverrides.global = MyHttpOverrides();
  Map<String, Map<String, String>> _languages = await di.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
  runApp(MyApp(languages: _languages));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key, required this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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
          fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
              AppConstants.languages[0].countryCode),
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
