import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:loglytics/analytics/analytics_interface.dart';

class AnalyticsImplementation implements AnalyticsInterface {
  AnalyticsImplementation(this._firebaseAnalytics);
  final FirebaseAnalytics _firebaseAnalytics;

  @override
  Future<void> logEvent(
          {required String name, Map<String, Object?>? parameters}) =>
      _firebaseAnalytics.logEvent(name: name, parameters: parameters);

  @override
  Future<void> resetAnalyticsData() => _firebaseAnalytics.resetAnalyticsData();

  @override
  Future<void> setCurrentScreen(
      {required String name, String? screenClassOverride}) {
    if (screenClassOverride != null) {
      return _firebaseAnalytics.setCurrentScreen(
          screenName: name, screenClassOverride: screenClassOverride);
    } else {
      return _firebaseAnalytics.setCurrentScreen(screenName: name);
    }
  }

  @override
  Future<void> setUserId(String? id) => _firebaseAnalytics.setUserId(id);

  @override
  Future<void> setUserProperty(
          {required String name, required String? value}) =>
      _firebaseAnalytics.setUserProperty(name: name, value: value);
}
