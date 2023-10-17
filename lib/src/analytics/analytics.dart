import 'package:loglytics/loglytics.dart';

/// Base class to be inherited when specifying analytics for a specific feature or part of your project.
///
/// Comes with an [AnalyticsService] to facilitate easy logging of analytics.
class Analytics {
  Analytics();
  late final AnalyticsService service;
}
