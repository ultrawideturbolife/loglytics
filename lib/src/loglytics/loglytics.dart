import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:loglytics/src/loglytics/const_loglytics.dart';

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
  // Used to register and provider the proper [Analytics]
  static final GetIt _getIt = GetIt.instance;

  /// Used to grab the proper [Analytics] implementation or provide a default one.
  D get _getAnalytics {
    try {
      return _getIt.get<D>()
        ..initialise(
          loglytics: this,
          analyticsImplementation: _analyticsImplementation,
          crashReportsImplementation: _crashReportsImplementation,
        );
    } on Error catch (_) {
      return (Analytics()
        ..initialise(
          loglytics: this,
          analyticsImplementation: _analyticsImplementation,
          crashReportsImplementation: _crashReportsImplementation,
        )) as D;
    } catch (error) {
      logError('Something went wrong grabbing the analytics data for $runtimeType.', error: error);
      return (Analytics()
        ..initialise(
          loglytics: this,
          analyticsImplementation: _analyticsImplementation,
          crashReportsImplementation: _crashReportsImplementation,
        )) as D;
    }
  }

  /// Provides the configured [Analytics] functionality through the [Loglytics] mixin.
  late final D analytics = _getAnalytics;

  /// Used for showing the location (class) of a single log.
  late final _logLocation = runtimeType.toString();

  // --------------- SETUP --------------- SETUP --------------- SETUP --------------- \\

  static AnalyticsInterface? _analyticsImplementation;
  static AnalyticsInterface? get getAnalyticsInterface => _analyticsImplementation;

  static CrashReportsInterface? _crashReportsImplementation;
  static CrashReportsInterface? get getCrashReportsInterface => _crashReportsImplementation;

  static bool _shouldLogAnalytics = true;
  static bool _setupConstLoglytics = true;

  static int? _errorStackTraceEnd;
  static const int _errorStackTraceEndDefault = 8;

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
    int? errorStackTraceEnd,
    bool setupConstLoglytics = true,
  }) {
    _analyticsImplementation = analyticsImplementation;
    _crashReportsImplementation = crashReportsImplementation;
    if (shouldLogAnalytics != null) _shouldLogAnalytics = shouldLogAnalytics;
    if (analytics != null) {
      analytics(AnalyticsFactory(getIt: _getIt));
    }
    _errorStackTraceEnd = errorStackTraceEnd ?? _errorStackTraceEndDefault;
    _setupConstLoglytics = setupConstLoglytics;
    if (_setupConstLoglytics) {
      ConstLoglytics.setup(
        crashReportsImplementation: crashReportsImplementation,
        analyticsImplementation: analyticsImplementation,
        errorStackTraceEnd: errorStackTraceEnd,
        shouldLogAnalytics: shouldLogAnalytics,
      );
    }
  }

  /// Used to configure the logging and analytic abilities of the [Loglytics].
  static void dispose() {
    _analyticsImplementation = null;
    _crashReportsImplementation = null;
    _shouldLogAnalytics = true;
    _errorStackTraceEnd = null;
    if (_setupConstLoglytics) ConstLoglytics.dispose();
  }

  // --------------- REGULAR --------------- REGULAR --------------- REGULAR --------------- \\

  /// Logs a regular [message] with [LogType.info] as [debugPrint].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void log(
    String message, {
    bool addToCrashReports = true,
  }) =>
      _logMessage(
        message: message,
        logType: LogType.info,
        addToCrashReports: addToCrashReports,
      );

  /// Logs a warning [message] with [LogType.warning] as [debugPrint].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void logWarning(
    String message, {
    bool addToCrashReports = true,
  }) =>
      _logMessage(
        message: message,
        logType: LogType.warning,
        addToCrashReports: addToCrashReports,
      );

  /// Logs an error [message] with [LogType.error] as [debugPrint].
  ///
  /// Also tries to send the log with optional [error], [stackTrace] and [fatal] boolean to your
  /// [CrashReportsInterface] implementation should you have configured one with the
  /// [Loglytics.setup] method.
  void logError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool fatal = false,
    bool printStack = true,
    bool addToCrashReports = true,
  }) {
    var _stackTrace = stackTrace ?? StackTrace.current;
    var hasError = error != null;
    if (hasError) {
      _crashReportsImplementation?.recordError(
        error,
        _stackTrace,
        fatal: fatal,
      );
    }
    _logMessage(
      message: message,
      logType: LogType.error,
      addToCrashReports: addToCrashReports,
    );
    if (hasError) {
      _logMessage(
        message: error.toString(),
        logType: LogType.error,
        addToCrashReports: false,
      );
    }
    if (printStack) {
      debugPrintStack(
          stackTrace: stackTrace, maxFrames: _errorStackTraceEnd ?? _errorStackTraceEndDefault);
    }
  }

  /// Logs a success [message] with [LogType.success] as [debugPrint].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void logSuccess(
    String message, {
    bool addToCrashReports = true,
  }) =>
      _logMessage(
        message: message,
        logType: LogType.success,
        addToCrashReports: addToCrashReports,
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
        '${LogType.analytic.icon} '
        '$name${value != null ? ': $value' : ''}'
        '${parameters != null ? ': $parameters' : ''}',
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
    String? description,
    LogType logType = LogType.info,
    bool addToCrashReports = true,
  }) =>
      _logValue(
        description: description,
        value: value,
        logType: logType,
        addToCrashReports: addToCrashReports,
      );

  /// Logs a [key], [value] and optional [message] with a default [LogType.info] as [debugPrint].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void logKeyValue(
    String key,
    Object? value, {
    String? message,
    LogType logType = LogType.info,
    bool addToCrashReports = true,
  }) =>
      _logKeyValue(
        key: key,
        description: message,
        value: value,
        logType: logType,
        addToCrashReports: addToCrashReports,
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
    bool addToCrashReports = true,
  }) =>
      _logIterable(
        iterable: list,
        description: message,
        logType: logType,
        addToCrashReports: addToCrashReports,
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
    bool addToCrashReports = true,
  }) =>
      _logIterable(
        iterable: set,
        description: message,
        logType: logType,
        addToCrashReports: addToCrashReports,
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
    bool addToCrashReports = true,
  }) =>
      _logMap(
        map: map,
        description: message,
        logType: logType,
        addToCrashReports: addToCrashReports,
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
    bool addToCrashReports = true,
  }) =>
      _logValues(
        map: map,
        description: message,
        addToCrashReports: addToCrashReports,
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
    bool addToCrashReports = true,
  }) {
    if (addToCrashReports) _tryLogCrashReportMessage(message);
    debugPrint(
      '$time '
      '[$_logLocation] '
      '${logType.icon} $message',
    );
  }

  /// Used under the hood to log a [value] and [logType] with optional [description].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logValue({
    required Object? value,
    required LogType logType,
    required addToCrashReports,
    required String? description,
  }) {
    if (addToCrashReports) _tryLogCrashReportValue(value, description);
    final _time = time;
    debugPrint(
        '$_time [$_logLocation] 💾 [VALUE] ${description != null ? '$description: ' : ''}$value');
  }

  /// Used under the hood to log a [key], [value] and [logType] with optional [description].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logKeyValue({
    required String key,
    required Object? value,
    required LogType logType,
    required addToCrashReports,
    required String? description,
  }) {
    _tryLogCrashReportKeyValue(key, value, description);
    debugPrint(
      '$time '
      '[$_logLocation] '
      '${description != null ? '${logType.icon} $description ' : ''}'
      '🔑 [KEY] $key '
      '💾 [VALUE] $value',
    );
  }

  /// Used under the hood to log an [iterable] and [logType] with optional [description].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logIterable<T extends Object?>({
    required Iterable<T> iterable,
    LogType logType = LogType.info,
    required addToCrashReports,
    String? description,
  }) {
    for (T value in iterable) {
      _logValue(
        value: value,
        logType: logType,
        description: description,
        addToCrashReports: addToCrashReports,
      );
    }
  }

  /// Used under the hood to log a [map] and [logType] with optional [description].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logMap({
    required Map<String, Object?> map,
    LogType logType = LogType.info,
    required addToCrashReports,
    String? description,
  }) =>
      map.forEach(
        (key, value) {
          _logKeyValue(
            key: key,
            value: value,
            logType: logType,
            description: description,
            addToCrashReports: addToCrashReports,
          );
        },
      );

  /// Used under the hood to log a [map]'s values and [logType] with optional [description].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setup] method.
  void _logValues<K extends Object?, V extends Object?>({
    required Map<K, V> map,
    String? description,
    LogType logType = LogType.info,
    required addToCrashReports,
  }) =>
      map.forEach(
        (_, value) {
          _logValue(
            value: value,
            logType: logType,
            description: description,
            addToCrashReports: addToCrashReports,
          );
        },
      );

  // --------------- CRASHLYTICS --------------- CRASHLYTICS --------------- CRASHLYTICS --------------- \\

  /// Used under the hood to try and log a crashlytics [message] with [logType].
  void _tryLogCrashReportMessage(String message) => _crashReportsImplementation?.log(message);

  /// Used under the hood to try and log a crashlytics [key] and [value] with [logType].
  void _tryLogCrashReportKeyValue(
    String key,
    Object? value,
    Object? description,
  ) =>
      _crashReportsImplementation
          ?.log('${description != null ? '$description: ' : ''}{ $key: $value }');

  /// Used under the hood to try and log a crashlytics [value] with [logType].
  void _tryLogCrashReportValue(
    Object? value,
    Object? description,
  ) {
    _crashReportsImplementation
        ?.log('${description != null ? '$description: ' : 'value: '} $value');
  }
}

extension on Analytics {
  void initialise({
    required Loglytics? loglytics,
    required AnalyticsInterface? analyticsImplementation,
    required CrashReportsInterface? crashReportsImplementation,
  }) =>
      service = AnalyticsService(
          loglytics: loglytics,
          analyticsImplementation: analyticsImplementation,
          crashReportsImplementation: crashReportsImplementation);
}
