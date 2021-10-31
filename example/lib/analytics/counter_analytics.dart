import 'package:loglytics/loglytics.dart';

class CounterAnalytics extends AnalyticsWrapper<CounterSubjects, CounterParameters> {
  @override
  CounterSubjects get subjects => _counterSubjects;
  late final CounterSubjects _counterSubjects = CounterSubjects();

  @override
  CounterParameters get parameters => _counterParameters;
  late final CounterParameters _counterParameters = CounterParameters();
}

class CounterSubjects extends AnalyticsSubjects {
  final String counterButton = 'counter_button';
  final String incrementCounter = 'increment_counter';
}

class CounterParameters extends AnalyticsParameters {
  final String amount = 'amount';
}
