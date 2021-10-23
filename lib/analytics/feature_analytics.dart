import 'package:loglytics/loglytics.dart';

/// Used to wrap implementations of [FeatureSubjects] and [FeatureParameters] for a specific feature.
///
/// Each feature in your app should have its own [FeatureAnalytics] implementation with its own
/// respective [FeatureSubjects] and [FeatureParameters] implementations.
///
/// By then specifying the implementations as generic arguments to a [LogService] like
/// LogService<FeatureSubjectsImplementation, FeatureParametersImplementation>
/// the [LogService.analytics] will have access to these implementations. Do remember to also
/// override [LogService.featureAnalytics] and provide your implementation of this class to
/// complete the setup.
abstract class FeatureAnalytics<S extends FeatureSubjects, P extends FeatureParameters> {
  S get subjects;
  P get parameters;
}

/// Used to specify analytic subject names for a specific feature.
abstract class FeatureSubjects {}

/// Used to specify analytic parameter names for a specific feature.
abstract class FeatureParameters {}
