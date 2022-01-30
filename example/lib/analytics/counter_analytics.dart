import 'package:loglytics/loglytics.dart';

class CounterAnalytics extends Analytics {
  final String counterButton = 'counter_button';
  final String _counterView = 'counter_view';

  void viewPage() => service.viewed(subject: _counterView);
}
