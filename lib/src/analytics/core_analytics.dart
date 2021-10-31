import 'package:loglytics/loglytics.dart';

/// Default [AnalyticsWrapper] wrapper for providing default subjects and parameters.
///
/// This class is used to provide default analytic functionality through [Loglytics.defaultAnalytics]
/// when no [AnalyticsSubjects] or [AnalyticsParameters] are specified while using a [Loglytics] mixin.
class DefaultAnalytics extends AnalyticsWrapper<DefaultSubjects, DefaultParameters> {
  @override
  DefaultSubjects get subjects => _defaultSubjects;
  late final DefaultSubjects _defaultSubjects = DefaultSubjects();

  @override
  DefaultParameters get parameters => _defaultParameters;
  late final DefaultParameters _defaultParameters = DefaultParameters();
}

/// [AnalyticsSubjects] implementation for [DefaultAnalytics].
class DefaultSubjects extends AnalyticsSubjects {
  final String form = 'form';
  final String screen = 'screen';
  final String button = 'button';
  final String dialog = 'dialog';
  final String snackbar = 'snackbar';
  final String bottomSheet = 'bottom_sheet';
  final String item = 'item';
  final String image = 'image';
  final String field = 'field';
  final String icon = 'icon';
  final String text = 'text';
  final String menu = 'menu';

  final String login = 'login';
  final String logout = 'logout';
  final String create = 'create';
  final String update = 'update';
  final String delete = 'delete';
}

/// [AnalyticsParameters] implementation for [DefaultAnalytics].
class DefaultParameters extends AnalyticsParameters {
  final String id = 'id';
  final String name = 'name';
  final String duration = 'duration';
  final String date = 'date';
  final String time = 'time';
  final String dateTime = 'date_time';
  final String type = 'type';
  final String amount = 'amount';
  final String location = 'location';
  final String percentage = 'percentage';
  final String target = 'target';
  final String targetId = 'targetId';
  final String source = 'source';
  final String sourceId = 'sourceId';
  final String info = 'info';
}
