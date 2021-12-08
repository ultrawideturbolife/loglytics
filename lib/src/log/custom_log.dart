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
  bool addToCrashReports = true,
}) {
  if (addToCrashReports) {
    crashReportsInterface?.log('[$location] '
        '${logType.name}: '
        '$message');
  }
  debugPrint(
    '$_time '
    '[$location] '
    '${logType.icon} $message',
  );
}

void customLogError({
  required String message,
  required String location,
  Object? error,
  StackTrace? stackTrace,
  bool fatal = false,
  bool printStack = true,
  bool addToCrashReports = true,
  bool forceRecordError = false,
  CrashReportsInterface? crashReportsInterface,
}) {
  StackTrace? _stackTrace;
  try {
    _stackTrace = stackTrace ??
        StackTrace.fromString(
          StackTrace.current.toString().split('\n').sublist(1).join('\n'),
        );
  } catch (error) {
    _stackTrace = null;
  }
  var hasError = error != null;
  if (hasError || forceRecordError) {
    assert(crashReportsInterface != null,
        'Add crashReportsInterface to customLogError method');
    crashReportsInterface!.recordError(
      error,
      _stackTrace,
      fatal: fatal,
    );
  }
  customLog(
    message: message,
    logType: LogType.error,
    addToCrashReports: addToCrashReports,
    location: location,
    crashReportsInterface: crashReportsInterface,
  );
  if (hasError) {
    customLog(
      message: error.toString(),
      logType: LogType.error,
      addToCrashReports: false,
      location: location,
    );
  }
  if (printStack) {
    debugPrintStack(stackTrace: stackTrace);
  }
}

/// Used to format the time in each log.
extension on DateTime {
  String get hourMinuteSecond => '${hour < 10 ? '0$hour' : hour}:'
      '${minute < 10 ? '0$minute' : minute}:'
      '${second < 10 ? '0$second' : second}';
}

/// Used to specify the time in each log.
String get _time => '[${DateTime.now().hourMinuteSecond}]';
