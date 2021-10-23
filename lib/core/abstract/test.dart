import 'package:loglytics/core/abstract/analytics_strings.dart';
import 'package:loglytics/core/abstract/log_service.dart';
import 'package:loglytics/core/analytics/example_analytics.dart';

class TestClass with LogService<ExampleAnalyticsSubjects, ExampleAnalyticsParameters> {
  void wtf() {
    analytics.tap(subject: (subjects) => subjects.subject);
  }

  @override
  AnalyticsStrings<ExampleAnalyticsSubjects, ExampleAnalyticsParameters>? get analyticsStrings =>
      ExampleAnalytics();
}
