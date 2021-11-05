import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../loglytics.dart';
import '../analytics/analytics_interface.dart';
import '../analytics/analytics_service.dart';
import '../crash_reports/crash_reports_interface.dart';
import '../extensions/date_time_extensions.dart';
import '../extensions/log_type_extensions.dart';

/// Used to provide all logging, analytics and crashlytics functionality to a class of your choosing.
///
/// If you want to make use of the analytic functionality use [Loglytics.setup] to provide your
/// implementations of the [AnalyticsInterface] and [CrashReportsInterface]. After doing so you can
/// add the [Loglytics] mixin to any class where you would like to add logging and/or analytics to.
/// In order to have access to the appropriate [Analytics] implementation for a specific
/// feature or part of your project you should add the implementation as generic arguments to a
/// [Loglytics] like Loglytics<CounterAnalytics>.
///
/// Defining the generic [Analytics] is optional however as the [Loglytics] will also work without
/// it. When no generic is specified you can even use our basic analytic functionality through the
/// default [Analytics.core] getter that's accessible through [Loglytics.analytics].
mixin Loglytics<D extends Analytics> {
  late final AnalyticsService<D> _analyticsService = AnalyticsService<D>(
    analyticsData: _analyticsData,
    analyticsImplementation: _analyticsImplementation,
    crashReportsImplementation: _crashReportsImplementation,
    loglytics: this,
  );

  // Used to register and provider the proper [Analytics]
  static final GetIt _getIt = GetIt.asNewInstance();

  /// Used to grab the proper [Analytics] implementation or provide a default one.
  dynamic get _analyticsData {
    try {
      return _getIt.get<D>();
    } catch (_) {
      return const Analytics();
    }
  }

  /// Provides the configured [AnalyticsService] functionality through the [Loglytics] mixin.
  ///
  /// The [AnalyticsService] will have access to the specified [Analytics] or default to the basic one.
  AnalyticsService<D> get analytics => _analyticsService;

  /// Used for showing the location (class) of a single log.
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
  ///
  /// Use the [analyticsImplementation] and [crashReportsImplementation] to specify your implementations
  /// of both functionalities. This is optional as the [Loglytics] can also be used as a pure logger.
  /// The [shouldLogAnalytics] boolean can be set to turn the debug logging of analytics on or off.
  /// This does not turn your analytics off, it only disables the debug logging.
  /// Populate the [analytics] parameter with callbacks to your [Analytics] implementations.
  /// Example: [() => CounterAnalytics(), () => CookieAnalytics()].
  static void setup({
    AnalyticsInterface? analyticsImplementation,
    CrashReportsInterface? crashReportsImplementation,
    bool? shouldLogAnalytics,
    void Function(AnalyticsFactory analyticsFactory)? analytics,
  }) {
    _analyticsImplementation = analyticsImplementation;
    _isAnalyticsEnabled = _analyticsImplementation != null;
    _crashReportsImplementation = crashReportsImplementation;
    _isCrashLyticsEnabled = _crashReportsImplementation != null;
    if (shouldLogAnalytics != null) _shouldLogAnalytics = shouldLogAnalytics;
    if (analytics != null) {
      analytics(AnalyticsFactory(getIt: _getIt));
    }
  }

  /// Used to configure the logging and analytic abilities of the [Loglytics].
  static Future<void> dispose({
    bool disposeAnalyticsImplementation = true,
    bool disposeCrashReportsImplementation = true,
  }) async {
    _analyticsImplementation = null;
    _crashReportsImplementation = null;
    _shouldLogAnalytics = true;
    await _getIt.reset();
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
    bool printStack = true,
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
    if (printStack) {
      _logMessage(
          message: stack?.toString() ??
              StackTrace.current.toString().split('\n').sublist(2, 8).join('\n'),
          logType: LogType.error);
    }
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
        '$time '
        '[$_logLocation] '
        '${LogType.analytic.icon} $name${value != null ? ' : $value' : ''}',
      );
      parameters?.forEach(
        (key, value) {
          debugPrint(
            '$time '
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
      '$time '
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
      '$time '
      '[$_logLocation] '
      '${message != null ? '${logType.icon} $message ' : ''}'
      '🔑 [KEY] $key',
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
    final _time = time;
    if (message != null) debugPrint('$_time [$_logLocation] ${'${logType.icon} $message '}');
    debugPrint('$_time [$_logLocation] 💾 [VALUE] $value');
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
      '$time '
      '[$_logLocation] '
      '${message != null ? '${logType.icon} $message ' : ''}'
      '🔑 [KEY] $key '
      '💾 [VALUE] $value',
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
