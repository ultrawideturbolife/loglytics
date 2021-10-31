import 'package:flutter/cupertino.dart';
import 'package:loglytics/loglytics.dart';

/// Used to wrap implementations of [LoglyticsSubjects] and [LoglyticsParameters] for a specific feature.
///
/// Each feature in your app should have its own [LoglyticsWrapper] implementation with its own
/// respective [LoglyticsSubjects] and [LoglyticsParameters] implementations. Check out the [Loglytics]
/// documentation for more info on how to use these as part of your analytics solution.
///
/// Template:
///
/// class TemplateAnalytics extends LoglyticsWrapper<TemplateSubjects, TemplateParameters> {
///   @override
///   TemplateSubjects get subjects => _counterSubjects;
///   late final TemplateSubjects _counterSubjects = TemplateSubjects();
///
///   @override
///   TemplateParameters get parameters => _counterParameters;
///   late final TemplateParameters _counterParameters = TemplateParameters();
/// }
///
/// class TemplateSubjects extends LoglyticsSubjects {}
///
/// class TemplateParameters extends LoglyticsParameters {}
@immutable
abstract class LoglyticsWrapper<S extends LoglyticsSubjects, P extends LoglyticsParameters> {
  S get subjects;
  P get parameters;
}

/// Used to specify analytic subject names.
@immutable
abstract class LoglyticsSubjects {}

/// Used to specify analytic parameter names.
@immutable
abstract class LoglyticsParameters {}
