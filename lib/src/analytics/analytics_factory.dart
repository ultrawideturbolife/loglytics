import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:loglytics/loglytics.dart';

/// Used to register analytics objects via the [Loglytics.setUp] method.
@protected
class AnalyticsFactory {
  const AnalyticsFactory({
    required GetIt getIt,
  }) : _getIt = getIt;

  final GetIt _getIt;

  void registerAnalytic<A extends Analytics>(A Function() analytic) {
    _getIt.registerFactory<A>(analytic);
  }
}
