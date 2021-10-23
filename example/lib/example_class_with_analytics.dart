import 'package:loglytics/core/abstract/log_service.dart';

import 'example_analytics.dart';

class ExampleClassWithAnalytics
    with LogService<ExampleAnalyticsSubjects, ExampleAnalyticsParameters> {
  void example() {
    analytics.tap(subject: (subjects) => subjects.exampleButton);
    analytics.userProperty(property: (subjects) => subjects.userId, value: 123);
    analytics.update(
      subject: (subjects) => subjects.exampleEntity,
      parameters: (parameters) => {
        parameters.exampleParameterOne: false,
        parameters.exampleParameterTwo: 1,
      },
    );
    analytics.success(subject: (subjects) => subjects.updateExample);
  }

  @override
  SubjectsAndParameters<ExampleAnalyticsSubjects, ExampleAnalyticsParameters>
      get subjectsAndParameters => ExampleAnalytics();
}
