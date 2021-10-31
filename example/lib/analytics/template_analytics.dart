import 'package:loglytics/loglytics.dart';

class TemplateAnalytics extends LoglyticsWrapper<TemplateSubjects, TemplateParameters> {
  @override
  TemplateSubjects get subjects => _counterSubjects;
  late final TemplateSubjects _counterSubjects = TemplateSubjects();

  @override
  TemplateParameters get parameters => _counterParameters;
  late final TemplateParameters _counterParameters = TemplateParameters();
}

class TemplateSubjects extends LoglyticsSubjects {}

class TemplateParameters extends LoglyticsParameters {}
