import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsApi {
  static final _instance = FirebaseAnalytics.instance;

  static void userLogin(String loginMethod) async {
    return _instance.logLogin(loginMethod: loginMethod);
  }
  Future<void> testSetUserId() async {
    await _instance.setUserId(id: 'some-user');
  }

  Future<void> testSetAnalyticsCollectionEnabled() async {
    await _instance.setAnalyticsCollectionEnabled(false);
    await _instance.setAnalyticsCollectionEnabled(true);
  }

  Future<void> testSetSessionTimeoutDuration() async {
    await _instance.setSessionTimeoutDuration(const Duration(milliseconds: 20000));
  }

  Future<void> testSetUserProperty() async {
    await _instance.setUserProperty(name: 'regular', value: 'indeed');
  }

  Future<void> testSetConsent() async {
    await _instance.setConsent(
      adStorageConsentGranted: true,
      adUserDataConsentGranted: true,
      adPersonalizationSignalsConsentGranted: true,
    );
  }

  Future<void> testAppInstanceId() async {
    String? id = await _instance.appInstanceId;
    if (id != null) {
      print('appInstanceId: $id');
    } else {
      print('appInstanceId failed, consent declined');
    }
  }

  Future<void> testResetAnalyticsData() async {
    await _instance.resetAnalyticsData();
  }

  Future<void> testInitiateOnDeviceConversionMeasurement() async {
    await _instance.initiateOnDeviceConversionMeasurementWithEmailAddress('visalmey007@gmail.com');
  }
}