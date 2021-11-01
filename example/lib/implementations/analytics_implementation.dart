import 'package:loglytics/loglytics.dart';

class AnalyticsImplementation implements AnalyticsInterface {
  AnalyticsImplementation(this._yourAnalyticsProvider);
  final Object _yourAnalyticsProvider;

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) {
    // _yourAnalyticsProvider.logEvent(name: name, parameters: parameters);
    return Future.value(null); // Remove this.
  }

  @override
  Future<void> resetAnalyticsData() {
    // _yourAnalyticsProvider.resetAnalyticsData();
    return Future.value(null); // Remove this.
  }

  @override
  Future<void> setCurrentScreen({required String name, String? screenClassOverride}) {
    // if (screenClassOverride != null) {
    //   return _yourAnalyticsProvider.setCurrentScreen(
    //       screenName: name, screenClassOverride: screenClassOverride);
    // } else {
    //   return _yourAnalyticsProvider.setCurrentScreen(screenName: name);
    // }
    return Future.value(null); // Remove this.
  }

  @override
  Future<void> setUserId(String? id) {
    // _yourAnalyticsProvider.setUserId(id);
    return Future.value(null); // Remove this.
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) {
    // _yourAnalyticsProvider.setUserProperty(name: name, value: value);
    return Future.value(null); // Remove this.
  }
}
