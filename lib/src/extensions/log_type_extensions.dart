import 'package:loglytics/src/enums/log_type.dart';

/// Used to define a proper name per [LogType] when icons are not preferred.
extension LogTypeExtensions on LogType {
  String get name {
    switch (this) {
      case LogType.info:
        return '[INFO]';
      case LogType.warning:
        return '[WARNING]';
      case LogType.error:
        return '[ERROR]';
      case LogType.success:
        return '[SUCCESS]';
      case LogType.analytic:
        return '[ANALYTIC]';
    }
  }

  /// Used to define a proper icon per [LogType] when a name is not preferred.
  String get icon {
    switch (this) {
      case LogType.info:
        return '🗣 $name';
      case LogType.warning:
        return '⚠ $name';
      case LogType.error:
        return '❌ $name';
      case LogType.success:
        return '✅ $name';
      case LogType.analytic:
        return '📈 $name';
    }
  }
}
