import '../enums/log_level.dart';

/// Used to define a proper name per [LogLevel] when icons are not preferred.
extension LogLevelExtensions on LogLevel {
  String get tag {
    switch (this) {
      case LogLevel.trace:
        return '[TRACE]';
      case LogLevel.debug:
        return '[DEBUG]';
      case LogLevel.info:
        return '[INFO]';
      case LogLevel.analytic:
        return '[ANALYTIC]';
      case LogLevel.warning:
        return '[WARNING]';
      case LogLevel.error:
        return '[ERROR]';
      case LogLevel.fatal:
        return '[FATAL]';
    }
  }

  /// Used to define a proper icon per [LogLevel] when a name is not preferred.
  String get iconTag {
    switch (this) {
      case LogLevel.trace:
        return '⏱️ $tag';
      case LogLevel.debug:
        return '🐛 $tag';
      case LogLevel.info:
        return '🗣 $tag';
      case LogLevel.analytic:
        return '📊 $tag';
      case LogLevel.warning:
        return '🚧 $tag';
      case LogLevel.error:
        return '❌ $tag';
      case LogLevel.fatal:
        return '☠️ $tag';
    }
  }
}
