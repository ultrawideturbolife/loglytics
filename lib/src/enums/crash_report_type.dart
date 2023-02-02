import 'package:loglytics/loglytics.dart';

/// Used to indicate what type of leading information is added to the crash report.
enum CrashReportType {
  location,
  tagLocation,
  iconTagLocation,
}

extension CrashReportTypeExtension on CrashReportType {
  String parseLogType({
    required String location,
    required LogType logType,
  }) {
    switch (this) {
      case CrashReportType.location:
        return '[$location]';
      case CrashReportType.tagLocation:
        return '${logType.tag} [$location]';
      case CrashReportType.iconTagLocation:
        return '${logType.iconTag} [$location]';
    }
  }
}
