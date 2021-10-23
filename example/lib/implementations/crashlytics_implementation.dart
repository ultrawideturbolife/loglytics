import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:loglytics/core/abstract/crashlytics_interface.dart';

class CrashlyticsImplementation implements CrashlyticsInterface {
  CrashlyticsImplementation(this._firebaseCrashlytics);
  final FirebaseCrashlytics _firebaseCrashlytics;

  @override
  Future<void> log(String message) => _firebaseCrashlytics.log(message);

  @override
  Future<void> recordError(
    exception,
    StackTrace? stack, {
    reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) =>
      _firebaseCrashlytics.recordError(
        exception,
        stack,
        reason: reason,
        information: information,
        printDetails: printDetails,
        fatal: fatal,
      );

  @override
  Future<void> setCustomKey(String key, Object value) =>
      _firebaseCrashlytics.setCustomKey(key, value);

  @override
  Future<void> setUserIdentifier(String identifier) =>
      _firebaseCrashlytics.setUserIdentifier(identifier);
}
