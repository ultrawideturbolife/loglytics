import 'package:flutter/cupertino.dart';
import 'package:loglytics/loglytics.dart';

/// Used to wrap implementations of [FeatureSubjects] and [FeatureParameters] for a specific feature.
///
/// Each feature in your app should have its own [FeatureAnalytics] implementation with its own
/// respective [FeatureSubjects] and [FeatureParameters] implementations. Check out the [LogService]
/// documentation for more info on how to use these as part of your analytics solution.
///
/// Template:
///
/// class TemplateAnalytics extends FeatureAnalytics<TemplateSubjects, TemplateParameters> {
///   @override
///   TemplateSubjects get subjects => _counterSubjects;
///   late final TemplateSubjects _counterSubjects = TemplateSubjects();
///
///   @override
///   TemplateParameters get parameters => _counterParameters;
///   late final TemplateParameters _counterParameters = TemplateParameters();
/// }
///
/// class TemplateSubjects extends FeatureSubjects {}
///
/// class TemplateParameters extends FeatureParameters {}
@immutable
abstract class FeatureAnalytics<S extends FeatureSubjects, P extends FeatureParameters> {
  S get subjects;
  P get parameters;
}

/// Used to specify analytic subject names for a specific feature.
@immutable
abstract class FeatureSubjects {}

/// Used to specify analytic parameter names for a specific feature.
@immutable
abstract class FeatureParameters {}
