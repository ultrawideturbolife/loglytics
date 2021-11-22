import 'package:loglytics/loglytics.dart';

/// Base class to be inherited when specifying analytics for a specific feature or part of your project.
///
/// Comes with default commonly used [_CoreData] accessible through the [Analytics.core] getter.
class Analytics {
  Analytics();
  late final AnalyticsService service;
}
