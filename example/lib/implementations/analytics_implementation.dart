import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:loglytics/core/abstract/analytics_interface.dart';
import 'package:loglytics/core/abstract/log_service.dart';

class AnalyticsImplementation with LogService implements AnalyticsInterface {
  AnalyticsImplementation(this._firebaseAnalytics);
  final FirebaseAnalytics _firebaseAnalytics;

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) =>
      _firebaseAnalytics.logEvent(name: name, parameters: parameters);

  @override
  Future<void> resetAnalyticsData() => _firebaseAnalytics.resetAnalyticsData();

  @override
  Future<void> setCurrentScreen(
          {required String? screenName, String screenClassOverride = 'Flutter'}) =>
      _firebaseAnalytics.setCurrentScreen(
          screenName: screenName, screenClassOverride: screenClassOverride);

  @override
  Future<void> setUserId(String? id) => _firebaseAnalytics.setUserId(id);

  @override
  Future<void> setUserProperty({required String name, required String? value}) =>
      _firebaseAnalytics.setUserProperty(name: name, value: value);
}
