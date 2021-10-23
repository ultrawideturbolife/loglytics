abstract class AnalyticsInterface {
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  });

  Future<void> setUserId(String? id);

  Future<void> setCurrentScreen({
    required String? screenName,
    String screenClassOverride = 'Flutter',
  });

  Future<void> setUserProperty({
    required String name,
    required String? value,
  });

  Future<void> resetAnalyticsData();
}
