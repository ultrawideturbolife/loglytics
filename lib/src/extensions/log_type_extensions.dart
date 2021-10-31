import 'package:loglytics/src/enums/log_type.dart';

/// Used to define a proper name per [LogType] when icons are not preferred.
extension LogTypeExtensions on LogType {
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
