import 'package:flutter/foundation.dart';
import 'package:loglytics/loglytics.dart';

class CrashReportsImplementation implements CrashReportsInterface {
  CrashReportsImplementation(this._yourCrashReportsProvider);
  final Object _yourCrashReportsProvider;

  @override
  Future<void> log(String message) {
    // _yourCrashReportsProvider.log(message);
    return Future.value(null); // Remove this.
  }

  @override
  Future<void> recordError(
    exception,
    StackTrace? stack, {
    reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) {
    // _yourCrashReportsProvider.recordError(
    //     exception,
    //     stack,
    //     reason: reason,
    //     information: information,
    //     printDetails: printDetails,
    //     fatal: fatal,
    //   );
    return Future.value(null); // Remove this.
  }

  @override
  Future<void> setCustomKey(String key, Object value) {
    // _yourCrashReportsProvider.setCustomKey(key, value);
    return Future.value(null); // Remove this.
  }

  @override
  Future<void> setUserIdentifier(String identifier) {
    // _yourCrashReportsProvider.setUserIdentifier(identifier);
    return Future.value(null); // Remove this.
  }
}
