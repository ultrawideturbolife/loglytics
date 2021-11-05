import 'package:flutter/foundation.dart';

import '../crash_reports/crash_reports_interface.dart';
import '../enums/log_type.dart';
import '../extensions/log_type_extensions.dart';

/// Used to provide basic logging capabilities when using the [Loglytics] mixin is impossible.
void customLog({
  required String message,
  required String location,
  required LogType logType,
  CrashReportsInterface? crashReportsInterface,
}) {
  crashReportsInterface?.log('[$location] '
      '${logType.name}: '
      '$message');
  debugPrint(
    '$_time '
    '[$location] '
    '${logType.icon} $message',
  );
}

/// Used to format the time in each log.
extension on DateTime {
  String get hourMinuteSecond => '${hour < 10 ? '0$hour' : hour}:'
      '${minute < 10 ? '0$minute' : minute}:'
      '${second < 10 ? '0$second' : second}';
}

/// Used to specify the time in each log.
String get _time => '[${DateTime.now().hourMinuteSecond}]';
