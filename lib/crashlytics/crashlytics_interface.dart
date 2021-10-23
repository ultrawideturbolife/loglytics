abstract class CrashlyticsInterface {
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    bool fatal = false,
  });

  Future<void> log(String message);

  Future<void> setUserIdentifier(String identifier);

  Future<void> setCustomKey(String key, Object value);
}
