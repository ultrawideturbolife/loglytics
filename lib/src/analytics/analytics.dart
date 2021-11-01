import 'package:flutter/foundation.dart';

/// Base class to be inherited when specifying analytics for a specific feature or part of your project.
///
/// Comes with default commonly used [_CoreData] accessible through the [Analytics.core] getter.
@immutable
class Analytics {
  const Analytics();
  final _CoreData core = const _CoreData();
}

/// Used to provide basic data to facilitate basic analytics without any configuration.
class _CoreData {
  const _CoreData();
  final String form = 'form';
  final String screen = 'screen';
  final String button = 'button';
  final String radioButton = 'radio_button';
  final String fabButton = 'fab_button';
  final String switchButton = 'switch_button';
  final String dialog = 'dialog';
  final String popup = 'popup';
  final String snackbar = 'snackbar';
  final String bottomSheet = 'bottom_sheet';
  final String bottomBar = 'bottom_bar';
  final String image = 'image';
  final String field = 'field';
  final String icon = 'icon';
  final String text = 'text';
  final String menu = 'menu';
  final String list = 'list';
  final String item = 'item';
  final String step = 'step';
  final String value = 'value';
  final String header = 'header';
  final String leading = 'leading';
  final String trailing = 'trailing';
  final String drawer = 'drawer';
  final String tab = 'tab';
  final String checkbox = 'checkbox';
  final String slider = 'slider';
  final String datePicker = 'date_picker';
  final String timePicker = 'time_picker';
  final String dateTimePicker = 'date_time_picker';
  final String card = 'card';
  final String chip = 'chip';
  final String indicator = 'indicator';
  final String table = 'table';
  final String grid = 'grid';
  final String app = 'app';

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

  final String login = 'login';
  final String logout = 'logout';
  final String create = 'create';
  final String update = 'update';
  final String delete = 'delete';
}
