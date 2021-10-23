import 'package:loglytics/core/abstract/analytics_strings.dart';
import 'package:loglytics/core/abstract/log_service.dart';

import 'example_analytics.dart';

class ExampleClass with LogService<ExampleAnalyticsSubjects, ExampleAnalyticsParameters> {
  void example() {
    analytics.tap(subject: (subjects) => subjects.exampleSubject);
    analytics.create(
      subject: (subjects) => subjects.exampleSubject,
      parameters: (parameters) => {
        parameters.exampleParameter: 'example',
      },
    );
    analytics.success(subject: (subjects) => subjects.exampleSubject);
  }

  @override
  AnalyticsStrings<ExampleAnalyticsSubjects, ExampleAnalyticsParameters> get analyticsStrings =>
      ExampleAnalytics();
}
