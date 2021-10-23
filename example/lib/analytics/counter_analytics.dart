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
  final String counterButton = 'counter_button';
  final String incrementCounter = 'increment_counter';
}

class CounterParameters extends FeatureParameters {
  final String amount = 'amount';
}
