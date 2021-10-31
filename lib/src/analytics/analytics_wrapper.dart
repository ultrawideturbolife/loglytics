import 'package:flutter/cupertino.dart';
import 'package:loglytics/loglytics.dart';

/// Used to wrap implementations of [AnalyticsSubjects] and [AnalyticsParameters] for a specific feature.
///
/// Each feature in your app should have its own [AnalyticsWrapper] implementation with its own
/// respective [AnalyticsSubjects] and [AnalyticsParameters] implementations. Check out the [Loglytics]
/// documentation for more info on how to use these as part of your analytics solution.
///
/// Template:
///
/// class TemplateAnalytics extends AnalyticsWrapper<TemplateSubjects, TemplateParameters> {
///   @override
///   TemplateSubjects get subjects => _counterSubjects;
///   late final TemplateSubjects _counterSubjects = TemplateSubjects();
///
///   @override
///   TemplateParameters get parameters => _counterParameters;
///   late final TemplateParameters _counterParameters = TemplateParameters();
/// }
///
/// class TemplateSubjects extends AnalyticsSubjects {}
///
/// class TemplateParameters extends AnalyticsParameters {}
@immutable
abstract class AnalyticsWrapper<S extends AnalyticsSubjects, P extends AnalyticsParameters> {
  S get subjects;
  P get parameters;
}

/// Used to specify analytic subject names.
@immutable
abstract class AnalyticsSubjects {}

/// Used to specify analytic parameter names.
@immutable
abstract class AnalyticsParameters {}
