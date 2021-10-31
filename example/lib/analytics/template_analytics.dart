import 'package:loglytics/loglytics.dart';

class TemplateAnalytics extends AnalyticsWrapper<TemplateSubjects, TemplateParameters> {
  @override
  TemplateSubjects get subjects => _counterSubjects;
  late final TemplateSubjects _counterSubjects = TemplateSubjects();

  @override
  TemplateParameters get parameters => _counterParameters;
  late final TemplateParameters _counterParameters = TemplateParameters();
}

class TemplateSubjects extends AnalyticsSubjects {}

class TemplateParameters extends AnalyticsParameters {}
