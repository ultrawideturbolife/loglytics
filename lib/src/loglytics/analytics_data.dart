import 'package:flutter/foundation.dart';

@immutable
class AnalyticsData {
  const AnalyticsData();
  final _CoreData core = const _CoreData();
}

class _CoreData {
  const _CoreData();
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
  final String value = 'value';

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
