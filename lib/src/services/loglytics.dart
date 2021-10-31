import 'package:flutter/foundation.dart';
import 'package:loglytics/loglytics.dart';

import '../analytics/analytics_interface.dart';
import '../analytics/loglytics_wrapper.dart';
import '../crashlytics/crash_reports_interface.dart';
import 'analytics_service.dart';

/// All types of logging.
///
/// Each type has its own unique prefix and icon.
enum LogType {
  info,
  warning,
  error,
  success,
  analytic,
}

/// Used to provide all logging, analytics and crashlytics functionality to a class of your choosing.
///
/// If you want to make use of the analytic functionality use [Loglytics.setup] to provide your
/// implementations of the [AnalyticsInterface] and [CrashReportsInterface]. After doing so you can
/// add the [Loglytics] mixin to any class where you would like to add logging and/or analytics to.
/// In order to have access to the appropriate [LoglyticsSubjects] and [LoglyticsParameters]
/// implementations for a specific feature you should add these as generic arguments to a
/// [Loglytics] like Loglytics<LoglyticsSubjectsImplementation, LoglyticsParametersImplementation>.
/// Do remember to also override [Loglytics.wrapper] afterwards and provide your
/// implementation of the [LoglyticsWrapper] that holds the former specified
/// [LoglyticsSubjects] and [LoglyticsParameters] implementations to complete the setup. By doing so
/// the [Loglytics.analytics] will provide you with access to these implementations inside the
/// various [AnalyticsService] methods.
///
/// Defining the former is optional however as the [Loglytics] will also work as a pure logging
/// service. When using this mixing just for logging there is no need to define the
/// [LoglyticsSubjects] and [LoglyticsParameters] as generic arguments. Just add the mixin and enjoy
/// the ride.
mixin Loglytics<S extends LoglyticsSubjects, P extends LoglyticsParameters> {
  late final AnalyticsService<S, P> _analyticsService = AnalyticsService<S, P>(
    loglyticsSubjects: wrapper!.subjects,
    loglyticsParameters: wrapper!.parameters,
    analyticsImplementation: _analyticsImplementation,
    crashReportsImplementation: _crashReportsImplementation,
    loglytics: this,
  );

  /// Provides the configured [AnalyticsService] functionality through the [Loglytics].
  ///
  /// The [AnalyticsService] will have access to the specified [LoglyticsSubjects] and
  /// [LoglyticsParameters] as specified in the [Loglytics.wrapper] method that you should
  /// override before using this method.
  AnalyticsService<S, P> get analytics {
    assert(wrapper != null, 'Override the wrapper getter first.');
    return _analyticsService;
  }

  late final AnalyticsService<DefaultSubjects, DefaultParameters> _analyticsDefaultService =
      AnalyticsService<DefaultSubjects, DefaultParameters>(
    loglyticsSubjects: DefaultSubjects(),
    loglyticsParameters: DefaultParameters(),
    analyticsImplementation: _analyticsImplementation,
    crashReportsImplementation: _crashReportsImplementation,
    loglytics: this,
  );

  /// Provides default [AnalyticsService] functionality through the [Loglytics].
  ///
  /// The [AnalyticsService] will have access to the default subjects and parameters as specified
  /// in [DefaultSubjects] and [DefaultParameters]. If you want to use your own implementation have
  /// a look at the [LoglyticsWrapper] and [Loglytics] class documentations.
  AnalyticsService<DefaultSubjects, DefaultParameters> get defaultAnalytics =>
      _analyticsDefaultService;

  /// Override this method to provide the appropriate [LoglyticsWrapper] for a certain class.
  @protected
  LoglyticsWrapper<S, P>? get wrapper => null;

  /// Used for showing the location (class) of a single log.
  String get logLocation => _logLocation;
  late final String _logLocation = runtimeType.toString();

  // --------------- SETUP --------------- SETUP --------------- SETUP --------------- \\

  static AnalyticsInterface? _analyticsImplementation;
  static CrashReportsInterface? _crashReportsImplementation;

  static bool get isAnalyticsEnabled => _isAnalyticsEnabled;
  static bool _isAnalyticsEnabled = false;
  static bool get isCrashlyticsEnabled => _isCrashLyticsEnabled;
  static bool _isCrashLyticsEnabled = false;
  static bool get shouldLogAnalytics => _shouldLogAnalytics;
  static bool _shouldLogAnalytics = true;

  /// Used to configure the logging and analytic abilities of the [Loglytics].
  static void setup({
    AnalyticsInterface? analyticsImplementation,
    CrashReportsInterface? crashReportsImplementation,
    bool? shouldLogAnalytics,
  }) {
    _analyticsImplementation = analyticsImplementation;
    _isAnalyticsEnabled = _analyticsImplementation != null;
    _crashReportsImplementation = crashReportsImplementation;
    _isCrashLyticsEnabled = _crashReportsImplementation != null;
    if (shouldLogAnalytics != null) _shouldLogAnalytics = shouldLogAnalytics;
  }

  // --------------- REGULAR --------------- REGULAR --------------- REGULAR --------------- \\

  /// Logs a regular [message] with [LogType.info] as [debugPrint].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void log(String message) => _logMessage(
        message: message,
        logType: LogType.info,
      );

  /// Logs a warning [message] with [LogType.warning] as [debugPrint].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void logWarning(String message) => _logMessage(
        message: message,
        logType: LogType.warning,
      );

  /// Logs an error [message] with [LogType.error] as [debugPrint].
  ///
  /// Also tries to send the log with optional [error], [stack] and [fatal] boolean to your
  /// [CrashReportsInterface] implementation should you have configured one with the
  /// [Loglytics.setup] method.
  void logError(
    String message, {
    Object? error,
    StackTrace? stack,
    bool fatal = false,
  }) {
    _crashReportsImplementation?.recordError(
      error,
      stack ?? StackTrace.current,
      fatal: fatal,
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

  /// Logs a success [message] with [LogType.success] as [debugPrint].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void logSuccess(String message) => _logMessage(
        message: message,
        logType: LogType.success,
      );

  /// Logs (does not send!) an analytic [name] with [LogType.analytic] as [debugPrint].
  ///
  /// Also accepts logs an optional [value] or [parameters] and tries to send the message to your
  /// [CrashReportsInterface] implementation should you have configured one with the
  /// [Loglytics.setup] method.
  void logAnalytic({
    required String name,
    String? value,
    Map<String, Object?>? parameters,
  }) {
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

  /// Logs a [value] and optional [message] with a default [LogType.info] as [debugPrint].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void logValue(
    Object? value, {
    String? message,
    LogType logType = LogType.info,
  }) =>
      _logValue(
        message: message,
        value: value,
        logType: logType,
      );

  /// Logs a [list] and optional [message] with a default [LogType.info] as [debugPrint].
  ///
  /// Iterates over the given [list] and uses the [_logValue] method under the hood to log each item.
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void logList<T extends Object?>(
    List<T> list, {
    String? message,
    LogType logType = LogType.info,
  }) =>
      _logIterable(
        iterable: list,
        message: message,
        logType: logType,
      );

  /// Logs a [set] and optional [message] with a default [LogType.info] as [debugPrint].
  ///
  /// Iterates over the given [set] and uses the [_logValue] method under the hood to log each item.
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void logSet<T extends Object?>(
    Set<T> set, {
    String? message,
    LogType logType = LogType.info,
  }) =>
      _logIterable(
        iterable: set,
        message: message,
        logType: logType,
      );

  /// Logs a [map] and optional [message] with a default [LogType.info] as [debugPrint].
  ///
  /// Iterates over the given [map] and uses the [_logKeyValue] method under the hood to log each item.
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void logMap(
    Map<String, Object?> map, {
    String? message,
    LogType logType = LogType.info,
  }) =>
      _logMap(
        map: map,
        message: message,
        logType: logType,
      );

  /// Logs a [map]'s keys and optional [message] with a default [LogType.info] as [debugPrint].
  ///
  /// Iterates over the given [map] and uses the [_logKey] method under the hood to log each item.
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void logKeys<T extends Object?, E extends Object?>(
    Map<T, E> map, {
    String? message,
    LogType logType = LogType.info,
  }) =>
      _logKeys(
        map: map,
        message: message,
        logType: logType,
      );

  /// Logs a [map]'s values and optional [message] with a default [LogType.info] as [debugPrint].
  ///
  /// Iterates over the given [map] and uses the [_logValue] method under the hood to log each item.
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void logValues<T extends Object?, E extends Object?>(
    Map<T, E> map, {
    String? message,
    LogType logType = LogType.info,
  }) =>
      _logValues(
        map: map,
        message: message,
      );

  // --------------- CONVENIENCE --------------- CONVENIENCE --------------- CONVENIENCE --------------- \\

  /// Enables easy logging of class initialization.
  void logInit() => log('I am Initialized!');

  /// Enables easy logging of disposing classes.
  void logDispose() => log('I am Disposed!');

  // --------------- PRINTERS --------------- PRINTERS --------------- PRINTERS --------------- \\

  /// Used under the hood to log a [message] with [logType].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logMessage({
    required String message,
    required LogType logType,
  }) {
    _tryLogCrashlyticsMessage(message, logType);
    debugPrint(
      '$_time '
      '[$_logLocation] '
      '${logType.icon} $message',
    );
  }

  /// Used under the hood to log a [key] and [logType] with optional [message].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logKey({
    required Object? key,
    required LogType logType,
    String? message,
  }) {
    if (message != null) _tryLogCrashlyticsMessage(message, logType);
    _tryLogCrashlyticsKey(key, logType);
    debugPrint(
      '$_time '
      '[$_logLocation] '
      '${message != null ? '${logType.icon} $message ' : ''}'
      '🔑 $key',
    );
  }

  /// Used under the hood to log a [value] and [logType] with optional [message].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logValue({
    required Object? value,
    required LogType logType,
    String? message,
  }) {
    if (message != null) _tryLogCrashlyticsMessage(message, logType);
    _tryLogCrashlyticsValue(value, logType);
    final time = _time;
    if (message != null) debugPrint('$time [$_logLocation] ${'${logType.icon} $message '}');
    debugPrint('$time [$_logLocation] 💾 $value');
  }

  /// Used under the hood to log a [key], [value] and [logType] with optional [message].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logKeyValue({
    required String key,
    required Object? value,
    required LogType logType,
    String? message,
  }) {
    if (message != null) _tryLogCrashlyticsMessage(message, logType);
    _tryLogCrashlyticsKeyValue(key, value, logType);
    debugPrint(
      '$_time '
      '[$_logLocation] '
      '${message != null ? '${logType.icon} $message ' : ''}'
      '🔑 $key '
      '💾 $value',
    );
  }

  /// Used under the hood to log an [iterable] and [logType] with optional [message].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logIterable<T extends Object?>({
    required Iterable<T> iterable,
    LogType logType = LogType.info,
    String? message,
  }) {
    for (T value in iterable) {
      _logValue(
        value: value,
        logType: logType,
        message: message,
      );
    }
  }

  /// Used under the hood to log a [map] and [logType] with optional [message].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logMap({
    required Map<String, Object?> map,
    LogType logType = LogType.info,
    String? message,
  }) =>
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

  /// Used under the hood to log a [map]'s keys and [logType] with optional [message].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logKeys<K extends Object?, V extends Object?>({
    required Map<K, V> map,
    String? message,
    LogType logType = LogType.info,
  }) =>
      map.forEach(
        (key, _) {
          _logKey(
            key: key,
            logType: logType,
            message: message,
          );
        },
      );

  /// Used under the hood to log a [map]'s values and [logType] with optional [message].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logValues<K extends Object?, V extends Object?>({
    required Map<K, V> map,
    String? message,
    LogType logType = LogType.info,
  }) =>
      map.forEach(
        (_, value) {
          _logValue(
            value: value,
            logType: logType,
            message: message,
          );
        },
      );

  // --------------- CRASHLYTICS --------------- CRASHLYTICS --------------- CRASHLYTICS --------------- \\

  /// Used under the hood to try and log a crashlytics [message] with [logType].
  void _tryLogCrashlyticsMessage(
    String message,
    LogType logType,
  ) {
    _crashReportsImplementation?.log('[$_logLocation] '
        '${logType.name}: '
        '$message');
  }

  /// Used under the hood to try and log a crashlytics [key] and [value] with [logType].
  void _tryLogCrashlyticsKeyValue(
    String key,
    Object? value,
    LogType logType,
  ) {
    _crashReportsImplementation?.log('[$_logLocation] '
        '${logType.name}: '
        '$key: $value');
  }

  /// Used under the hood to try and log a crashlytics [key] with [logType].
  void _tryLogCrashlyticsKey(
    Object? key,
    LogType logType,
  ) {
    _crashReportsImplementation?.log('[$_logLocation] '
        '${logType.name}: '
        'key: $key');
  }

  /// Used under the hood to try and log a crashlytics [value] with [logType].
  void _tryLogCrashlyticsValue(
    Object? value,
    LogType logType,
  ) {
    _crashReportsImplementation?.log('[$_logLocation] '
        '${logType.name}: '
        'value: $value');
  }
}

// --------------- ENUM --------------- ENUM --------------- ENUM --------------- \\

/// Used to define a proper name per [LogType] when icons are not preferred.
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

  /// Used to define a proper icon per [LogType] when a name is not preferred.
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
