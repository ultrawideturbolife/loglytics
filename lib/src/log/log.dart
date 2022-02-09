part of '../loglytics/loglytics.dart';

/// Pure logger class to facilitate logging.
class Log {
  Log({
    required String location,
    int? maxLinesStackTrace,
  })  : _location = location,
        _maxLinesStackTrace = maxLinesStackTrace;

  /// Used to indicate the current location of the log.
  final String _location;

  /// Used to determine the max lines of the stack trace.
  final int? _maxLinesStackTrace;

  /// Used to properly handle chronological processing of events.
  late final EventBus _eventBus = EventBus();

  // --------------- REGULAR --------------- REGULAR --------------- REGULAR --------------- \\

  /// Logs a regular [message] with [LogType.info] default as [debugPrint].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setUp] method.
  void info(
    String message, {
    bool addToCrashReports = true,
    LogType logType = LogType.info,
    bool showTime = true,
    String? location,
  }) =>
      _logMessage(
        message: message,
        logType: logType,
        addToCrashReports: addToCrashReports,
        showTime: showTime,
        location: location,
      );

  /// Logs a warning [message] with [LogType.warning] as [debugPrint].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setUp] method.
  void warning(
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
  /// [Loglytics.setUp] method.
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool fatal = false,
    bool printStack = true,
    bool addToCrashReports = true,
    bool forceRecordError = false,
  }) {
    StackTrace _stackTrace;
    try {
      _stackTrace = stackTrace ??
          StackTrace.fromString(
            StackTrace.current.toString().split('\n').sublist(1).join('\n'),
          );
    } catch (error) {
      _stackTrace = StackTrace.current;
    }
    final hasError = error != null;
    if (hasError || forceRecordError) {
      _eventBus.tryAddCrashReport(
        Loglytics._crashReportsInterface?.recordError(
          error,
          _stackTrace,
          fatal: fatal,
        ),
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
        stackTrace: stackTrace,
        maxFrames: _maxLinesStackTrace,
      );
    }
  }

  /// Logs a success [message] with [LogType.success] as [debugPrint].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setUp] method.
  void success(
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
  /// [Loglytics.setUp] method.
  void analytic({
    required String name,
    String? value,
    Map<String, Object?>? parameters,
  }) {
    debugPrint(
      '$time '
      '[$_location] '
      '${LogType.analytic.icon} '
      '$name${value != null ? ': $value' : ''}'
      '${parameters != null ? ': $parameters' : ''}',
    );
  }

  // --------------- VALUES --------------- VALUES --------------- VALUES --------------- \\

  /// Logs a [value] and optional [message] with a default [LogType.info] as [debugPrint].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setUp] method.
  void value(
    Object? value,
    String? description, {
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
  /// configured one with the [Loglytics.setUp] method.
  void keyValue(
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
  /// configured one with the [Loglytics.setUp] method.
  void list<T extends Object?>(
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
  /// configured one with the [Loglytics.setUp] method.
  void set<T extends Object?>(
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
  /// configured one with the [Loglytics.setUp] method.
  void map(
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
  /// configured one with the [Loglytics.setUp] method.
  void values<T extends Object?, E extends Object?>(
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

  // --------------- PRINTERS --------------- PRINTERS --------------- PRINTERS --------------- \\

  /// Used under the hood to log a [message] with [logType].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setUp] method.
  void _logMessage({
    required String message,
    required LogType logType,
    bool addToCrashReports = true,
    bool showTime = true,
    String? location,
  }) {
    if (addToCrashReports) _tryLogCrashReportMessage(message);
    debugPrint(
      '${showTime ? '$time ' : ''}'
      '${location == null ? '[$_location] ' : '$location '}'
      '${logType.icon} $message',
    );
  }

  /// Used under the hood to log a [value] and [logType] with optional [description].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setUp] method.
  void _logValue({
    required Object? value,
    required LogType logType,
    required addToCrashReports,
    required String? description,
  }) {
    if (addToCrashReports) _tryLogCrashReportValue(value, description);
    final _time = time;
    debugPrint('$_time'
        '[$_location] '
        '${logType.icon} ${description != null ? '$description: ' : ''}$value');
  }

  /// Used under the hood to log a [key], [value] and [logType] with optional [description].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setUp] method.
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
      '[$_location] '
      '${description != null ? '${logType.icon} $description ' : ''}'
      '🔑 [KEY] $key '
      '💾 [VALUE] $value',
    );
  }

  /// Used under the hood to log an [iterable] and [logType] with optional [description].
  ///
  /// Also tries to send the log to your [CrashReportsInterface] implementation should you have
  /// configured one with the [Loglytics.setUp] method.
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
  /// configured one with the [Loglytics.setUp] method.
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
  /// configured one with the [Loglytics.setUp] method.
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
  void _tryLogCrashReportMessage(String message) => _eventBus.tryAddCrashReport(
      Loglytics._crashReportsInterface?.log('[$_location] $message'));

  /// Used under the hood to try and log a crashlytics [key] and [value] with [logType].
  void _tryLogCrashReportKeyValue(
    String key,
    Object? value,
    Object? description,
  ) =>
      _eventBus.tryAddCrashReport(Loglytics._crashReportsInterface?.log(
          '[$_location] ${description != null ? '$description: ' : ''}{ $key: $value }'));

  /// Used under the hood to try and log a crashlytics [value] with [logType].
  void _tryLogCrashReportValue(
    Object? value,
    Object? description,
  ) =>
      _eventBus.tryAddCrashReport(Loglytics._crashReportsInterface?.log(
          '[$_location] ${description != null ? '$description: ' : 'value: '} $value'));
}
