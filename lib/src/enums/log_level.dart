/// All levels of logging.
///
/// Each level has its own unique prefix and icon.
enum LogLevel {
  trace,
  debug,
  info,
  analytic,
  warning,
  error,
  fatal;

  /// Decides whether to show the log based on the [index] of the [LogLevel].
  bool skipLog(LogLevel logLevel) => index > logLevel.index;
}
