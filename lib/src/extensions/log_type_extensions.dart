import '../enums/log_type.dart';

/// Used to define a proper name per [LogType] when icons are not preferred.
extension LogTypeExtensions on LogType {
  String get tag {
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
      case LogType.value:
        return '[VALUE]';
      case LogType.debug:
        return '[DEBUG]';
      case LogType.mvvm:
        return '[MVVM]';
      case LogType.bloc:
        return '[BLOC]';
      case LogType.test:
        return '[TEST]';
    }
  }

  /// Used to define a proper icon per [LogType] when a name is not preferred.
  String get iconTag {
    switch (this) {
      case LogType.info:
        return '🗣 $tag';
      case LogType.warning:
        return '⚠ $tag';
      case LogType.error:
        return '❌ $tag';
      case LogType.success:
        return '✅ $tag';
      case LogType.analytic:
        return '📈 $tag';
      case LogType.value:
        return '💾 $tag';
      case LogType.debug:
        return '🐛 $tag';
      case LogType.mvvm:
        return '📚 $tag';
      case LogType.bloc:
        return '🧱 $tag';
      case LogType.test:
        return '🧪 $tag';
    }
  }
}
