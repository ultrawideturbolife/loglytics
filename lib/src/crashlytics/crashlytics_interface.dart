/// Exposes all crashlytics methods for own implementation.
abstract class CrashlyticsInterface {
  /// Logs an error by dynamic [exception] and possible [stack] and/or [fatal] boolean.
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    bool fatal = false,
  });

  /// Logs a message by String type [message].
  Future<void> log(String message);

  /// Sets a user identifier that usually persists through the apps lifecycle.
  Future<void> setUserIdentifier(String identifier);

  /// Sets a custom key for the user that usually persists through the apps lifecycle.
  Future<void> setCustomKey(String key, Object value);
}
