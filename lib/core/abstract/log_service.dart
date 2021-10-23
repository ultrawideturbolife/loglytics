import 'package:flutter/foundation.dart';
import 'package:loglytics/core/abstract/crashlytics_interface.dart';
import 'package:loglytics/core/abstract/subjects_and_parameters.dart';
import 'package:loglytics/core/services/analytics_service.dart';

import 'analytics_interface.dart';
import 'subjects_and_parameters.dart';

enum LogType { info, warning, error, success, analytic }

mixin LogService<S extends AnalyticsSubjects, P extends AnalyticsParameters> {
  late final AnalyticsService<S, P> _analyticsService = AnalyticsService<S, P>(
    analyticsSubjects: subjectsAndParameters!.subjects,
    analyticsParameters: subjectsAndParameters!.parameters,
    analyticsInterface: _analyticsInterface,
    logService: this,
  );

  AnalyticsService<S, P> get analytics {
    assert(subjectsAndParameters != null, 'Override the subjectsAndParameters getter first.');
    return _analyticsService;
  }

  SubjectsAndParameters<S, P>? get subjectsAndParameters => null;

  String get logLocation => _logLocation;
  late final String _logLocation = runtimeType.toString();

  // --------------- SETUP --------------- SETUP --------------- SETUP --------------- \\

  static AnalyticsInterface? _analyticsInterface;
  static bool _shouldLogAnalytics = true;
  static CrashlyticsInterface? _crashlyticsInterface;

  static bool get isAnalyticsEnabled => _isAnalyticsEnabled;
  static bool _isAnalyticsEnabled = false;
  static bool get isCrashlyticsEnabled => _isCrashLyticsEnabled;
  static bool _isCrashLyticsEnabled = false;
  static bool get shouldLogAnalytics => _shouldLogAnalytics;

  static void setup({
    AnalyticsInterface? analyticsInterface,
    bool? shouldLogAnalytics,
    CrashlyticsInterface? crashlyticsInterface,
  }) {
    _analyticsInterface = analyticsInterface;
    _isAnalyticsEnabled = _analyticsInterface != null;
    if (shouldLogAnalytics != null) _shouldLogAnalytics = shouldLogAnalytics;
    _crashlyticsInterface = crashlyticsInterface;
    _isCrashLyticsEnabled = _crashlyticsInterface != null;
  }

  // --------------- REGULAR --------------- REGULAR --------------- REGULAR --------------- \\

  void log(String message) => _logMessage(
        message: message,
        logType: LogType.info,
      );

  void logWarning(String message) => _logMessage(
        message: message,
        logType: LogType.warning,
      );

  void logError(String message, {Object? error, StackTrace? stack, bool fatal = false}) {
    _crashlyticsInterface?.recordError(
      error,
      stack ?? StackTrace.current,
      fatal: fatal,
      printDetails: false,
    );
    _logMessage(
      message: message,
      logType: LogType.error,
    );
    if (error != null) {
      _logMessage(message: error.toString(), logType: LogType.error);
    }
    _logMessage(
        message:
            stack?.toString() ?? StackTrace.current.toString().split('\n').sublist(2, 8).join('\n'),
        logType: LogType.error);
  }

  void logSuccess(String message) => _logMessage(
        message: message,
        logType: LogType.success,
      );

  void logAnalytic({required String name, String? value, Map<String, Object?>? parameters}) {
    if (_shouldLogAnalytics) {
      debugPrint(
        '$_time '
        '[$_logLocation] '
        '${LogType.analytic.icon} $name${value != null ? ' : $value' : ''}',
      );
      parameters?.forEach(
        (key, value) {
          debugPrint(
            '$_time '
            '[$_logLocation] '
            '${LogType.analytic.icon} '
            '{ $key '
            ': $value }',
          );
        },
      );
    }
  }

  // --------------- VALUES --------------- VALUES --------------- VALUES --------------- \\

  void logValue(Object? value, {String? message}) => _logValue(
        message: message,
        value: value,
        logType: LogType.info,
      );

  void logValueWarning(Object? value, {String? message}) => _logValue(
        message: message,
        value: value,
        logType: LogType.warning,
      );

  void logValueError(Object? value, {String? message}) => _logValue(
        message: message,
        value: value,
        logType: LogType.error,
      );

  void logValueSuccess(Object? value, {String? message}) => _logValue(
        message: message,
        value: value,
        logType: LogType.success,
      );

  void logList<T extends Object?>(List<T> list, {String? message}) => _logIterable(
        iterable: list,
        message: message,
      );

  void logSet<T extends Object?>(Set<T> set, {String? message}) => _logIterable(
        iterable: set,
        message: message,
      );

  void logMap(Map<String, Object?> map, {String? message}) => _logMap(
        map: map,
        message: message,
      );

  void logKeys<T extends Object?, E extends Object?>(Map<T, E> map, {String? message}) => _logKeys(
        map: map,
        message: message,
      );

  void logValues<T extends Object?, E extends Object?>(Map<T, E> map, {String? message}) =>
      _logValues(
        map: map,
        message: message,
      );

  // --------------- INIT --------------- INIT --------------- INIT --------------- \\

  void logInit() => log('I am Initialised!');
  void logDispose() => log('I am Disposed!');

  // --------------- PRINTERS --------------- PRINTERS --------------- PRINTERS --------------- \\

  void _logMessage({
    required String message,
    required LogType logType,
  }) {
    _tryLogCrashlyticsMessage(logType, message);
    debugPrint(
      '$_time '
      '[$_logLocation] '
      '${logType.icon} $message',
    );
  }

  void _logKey({
    required Object? key,
    required LogType logType,
    String? message,
  }) {
    if (message != null) _tryLogCrashlyticsMessage(logType, message);
    _tryLogCrashlyticsKey(key);
    debugPrint(
      '$_time '
      '[$_logLocation] '
      '${message != null ? '${logType.icon} $message ' : ''}'
      '🔑 $key',
    );
  }

  void _logValue({
    required Object? value,
    required LogType logType,
    String? message,
  }) {
    if (message != null) _tryLogCrashlyticsMessage(logType, message);
    _tryLogCrashlyticsValue(value);
    final time = _time;
    if (message != null) debugPrint('$time [$_logLocation] ${'${logType.icon} $message '}');
    debugPrint('$time [$_logLocation] 💾 $value');
  }

  void _logKeyValue({
    required String key,
    required Object? value,
    required LogType logType,
    String? message,
  }) {
    if (message != null) _tryLogCrashlyticsMessage(logType, message);
    _tryLogCrashlyticsKeyValue(key, value);
    debugPrint(
      '$_time '
      '[$_logLocation] '
      '${message != null ? '${logType.icon} $message ' : ''}'
      '🔑 $key '
      '💾 $value',
    );
  }

  void _logIterable<T extends Object?>({required Iterable<T> iterable, String? message}) =>
      iterable.forEach(
        (element) => _logValue(
          value: element,
          logType: LogType.info,
          message: message,
        ),
      );

  void _logMap(
          {required Map<String, Object?> map, String? message, LogType logType = LogType.info}) =>
      map.forEach(
        (key, value) {
          _logKeyValue(
            key: key,
            value: value,
            logType: logType,
            message: message,
          );
        },
      );

  void _logKeys<K extends Object?, V extends Object?>({required Map<K, V> map, String? message}) =>
      map.forEach(
        (key, _) {
          _logKey(
            key: key,
            logType: LogType.info,
            message: message,
          );
        },
      );

  void _logValues<K extends Object?, V extends Object?>(
          {required Map<K, V> map, String? message}) =>
      map.forEach(
        (_, value) {
          _logValue(
            value: value,
            logType: LogType.info,
            message: message,
          );
        },
      );

  // --------------- CRASHLYTICS --------------- CRASHLYTICS --------------- CRASHLYTICS --------------- \\

  void _tryLogCrashlyticsMessage(LogType logType, String message) {
    _crashlyticsInterface?.log('${logType.name}: $message');
  }

  void _tryLogCrashlyticsKeyValue(String key, Object? value) {
    _crashlyticsInterface?.log('$key: $value');
  }

  void _tryLogCrashlyticsKey(Object? key) {
    _crashlyticsInterface?.log('key: $key');
  }

  void _tryLogCrashlyticsValue(Object? value) {
    _crashlyticsInterface?.log('value: $value');
  }
}

// --------------- ENUM --------------- ENUM --------------- ENUM --------------- \\

extension on LogType {
  String get name {
    switch (this) {
      case LogType.info:
        return 'INFO';
      case LogType.warning:
        return 'WARNING';
      case LogType.error:
        return 'ERROR';
      case LogType.success:
        return 'SUCCESS';
      case LogType.analytic:
        return 'ANALYTIC';
    }
  }

  String get icon {
    switch (this) {
      case LogType.info:
        return '🗣';
      case LogType.warning:
        return '⚠';
      case LogType.error:
        return '❌';
      case LogType.success:
        return '✅';
      case LogType.analytic:
        return '📈';
    }
  }
}

// --------------- MISC --------------- MISC --------------- MISC --------------- \\

void customLog({
  required String message,
  required String location,
  required LogType logType,
  required CrashlyticsInterface? crashlyticsInterface,
}) {
  crashlyticsInterface?.log('${logType.name}: $message');
  debugPrint(
    '$_time '
    '[$location] '
    '${logType.icon} $message',
  );
}

extension on DateTime {
  String get hourMinuteSecond => '${hour < 10 ? '0$hour' : hour}:'
      '${minute < 10 ? '0$minute' : minute}:'
      '${second < 10 ? '0$second' : second}';
}

String get _time => '[${DateTime.now().hourMinuteSecond}]';
