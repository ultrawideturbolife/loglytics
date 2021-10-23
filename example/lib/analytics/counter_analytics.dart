import 'package:loglytics/loglytics.dart';

class CounterAnalytics extends FeatureAnalytics<CounterSubjects, CounterParameters> {
  @override
  CounterSubjects get subjects => _counterSubjects;
  late final CounterSubjects _counterSubjects = CounterSubjects();

  @override
  CounterParameters get parameters => _counterParameters;
  late final CounterParameters _counterParameters = CounterParameters();
}

class CounterSubjects extends FeatureSubjects {
  final String userId = 'user_id';
  final String exampleButton = 'example_button';
  final String exampleEntity = 'example_entity';
  final String updateExample = 'update_example';
  final String incrementCounter = 'increment_counter';
}

class CounterParameters extends FeatureParameters {
  final String exampleParameterOne = 'example_parameter_one';
  final String exampleParameterTwo = 'example_parameter_two';
  final String amount = 'amount';
}
