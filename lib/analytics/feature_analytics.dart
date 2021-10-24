import 'package:loglytics/loglytics.dart';

/// Used to wrap implementations of [FeatureSubjects] and [FeatureParameters] for a specific feature.
///
/// Each feature in your app should have its own [FeatureAnalytics] implementation with its own
/// respective [FeatureSubjects] and [FeatureParameters] implementations. Check out the [LogService]
/// documentation for more info on how to use these as part of your anakytics solution.
abstract class FeatureAnalytics<S extends FeatureSubjects, P extends FeatureParameters> {
  S get subjects;
  P get parameters;
}

/// Used to specify analytic subject names for a specific feature.
abstract class FeatureSubjects {}

/// Used to specify analytic parameter names for a specific feature.
abstract class FeatureParameters {}
