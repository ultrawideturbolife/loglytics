import 'package:loglytics/core/abstract/subjects_and_parameters.dart';

class CounterAnalytics
    extends SubjectsAndParameters<ExampleAnalyticsSubjects, ExampleAnalyticsParameters> {
  @override
  ExampleAnalyticsSubjects get subjects => _templatesSubjects;
  late final ExampleAnalyticsSubjects _templatesSubjects = ExampleAnalyticsSubjects();

  @override
  ExampleAnalyticsParameters get parameters => _templatesParameters;
  late final ExampleAnalyticsParameters _templatesParameters = ExampleAnalyticsParameters();
}

class ExampleAnalyticsSubjects extends AnalyticsSubjects {
  final String userId = 'user_id';
  final String exampleButton = 'example_button';
  final String exampleEntity = 'example_entity';
  final String updateExample = 'update_example';
  final String incrementCounter = 'increment_counter';
}

class ExampleAnalyticsParameters extends AnalyticsParameters {
  final String exampleParameterOne = 'example_parameter_one';
  final String exampleParameterTwo = 'example_parameter_two';
  final String amount = 'amount';
}
