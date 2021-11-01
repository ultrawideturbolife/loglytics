import 'package:loglytics/src/analytics/analytics.dart';

import '../../loglytics.dart';
import '../loglytics/loglytics.dart';
import 'analytic.dart';
import 'analytics_interface.dart';

/// Used to provide an easy interface for sending analytics.
///
/// Each [AnalyticType] has its own method that exposes implementations of predefined
/// [Analytics].
/// example you can use [AnalyticsService.tap] and it the will automatically provide you with the
/// proper [Analytics].
class AnalyticsService<A extends Analytics> {
  AnalyticsService({
    required A analyticsData,
    Loglytics? loglytics,
    AnalyticsInterface? analyticsImplementation,
    CrashReportsInterface? crashReportsImplementation,
  })  : _analyticsData = analyticsData,
        _loglytics = loglytics,
        _analyticsImplementation = analyticsImplementation,
        _crashReportsImplementation = crashReportsImplementation;

  final A _analyticsData;

  final Loglytics? _loglytics;
  final AnalyticsInterface? _analyticsImplementation;
  final CrashReportsInterface? _crashReportsImplementation;

  /// Used to identify the first input when sending a stream of similar analytics.
  Analytic? _firstInput;

  /// Sets a [userId] that persists throughout the app.
  ///
  /// This applies to your possible [_analyticsImplementation] as well as your
  /// [_crashReportsImplementation].
  void userId({required String userId}) {
    _analyticsImplementation?.setUserId(userId);
    _crashReportsImplementation?.setUserIdentifier(userId);
    _loglytics?.logAnalytic(name: 'user_id', value: userId);
  }

  /// Sets a user [property] and [value] that persists throughout the app.
  ///
  /// This applies to your possible [_analyticsImplementation] as well as your
  /// [_crashReportsImplementation].
  void userProperty({required String Function(A analytics) property, required Object? value}) {
    final name = property(_analyticsData);
    final _value = value?.toString() ?? '-';
    _analyticsImplementation?.setUserProperty(name: name, value: _value);
    _crashReportsImplementation?.setCustomKey(name, _value);
    _loglytics?.logAnalytic(name: name, value: _value);
  }

  /// Sends a custom analytic event by providing both [Analytics].
  ///
  /// This method may be used to log anything that is not covered by any other method in this class
  /// and expects an [Analytic] in return from the [analytic] callback.
  void event({required Analytic Function(A analytics) analytic}) =>
      _logEvent(analytic(_analyticsData));

  /// Sends an [AnalyticType.tap] and provides the appropriate [Analytics].
  void tap({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.tap,
        ),
      );

  /// Sends an [AnalyticType.click] and provides the appropriate [Analytics].
  void click({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.click,
        ),
      );

  /// Sends an [AnalyticType.focus] and provides the appropriate [Analytics].
  void focus({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.focus,
        ),
      );

  /// Sends an [AnalyticType.select] and provides the appropriate [Analytics].
  void select({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.select,
        ),
      );

  /// Sends an [AnalyticType.connect] and provides the appropriate [Analytics].
  void connect({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.connect,
        ),
      );

  /// Sends an [AnalyticType.connect] and provides the appropriate [Analytics].
  void disconnect({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.connect,
        ),
      );

  /// Sends an [AnalyticType.view] and provides the appropriate [Analytics].
  void view({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.view,
        ),
      );

  /// Sends an [AnalyticType.hide] and provides the appropriate [Analytics].
  void hide({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.hide,
        ),
      );

  /// Sends an [AnalyticType.open] and provides the appropriate [Analytics].
  void open({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.open,
        ),
      );

  /// Sends an [AnalyticType.close] and provides the appropriate [Analytics].
  void close({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.close,
        ),
      );

  /// Sends an [AnalyticType.fail] and provides the appropriate [Analytics].
  void fail({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.fail,
        ),
      );

  /// Sends an [AnalyticType.success] and provides the appropriate [Analytics].
  void success({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.success,
        ),
      );

  /// Sends an [AnalyticType.send] and provides the appropriate [Analytics].
  void send({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.send,
        ),
      );

  /// Sends an [AnalyticType.receive] and provides the appropriate [Analytics].
  void receive({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.receive,
        ),
      );

  /// Sends an [AnalyticType.valid] and provides the appropriate [Analytics].
  void valid({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.valid,
        ),
      );

  /// Sends an [AnalyticType.invalid] and provides the appropriate [Analytics].
  void invalid({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.invalid,
        ),
      );

  /// Sends an [AnalyticType.search] and provides the appropriate [Analytics].
  void search({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.search,
        ),
      );

  /// Sends an [AnalyticType.like] and provides the appropriate [Analytics].
  void like({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.like,
        ),
      );

  /// Sends an [AnalyticType.share] and provides the appropriate [Analytics].
  void share({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.share,
        ),
      );

  /// Sends an [AnalyticType.comment] and provides the appropriate [Analytics].
  void comment({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.comment,
        ),
      );

  /// Sends an [AnalyticType.input] and provides the appropriate [Analytics].
  ///
  /// Defaults to only sending the first analytic by settings [onlyFirstValue] to true.
  void input({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
    bool onlyFirstValue = true,
  }) {
    final analytic = Analytic(
      subject: subject(_analyticsData),
      parameters: parameters?.call(_analyticsData),
      type: AnalyticType.input,
    );
    if (_firstInput == null || !onlyFirstValue || !analytic.equals(_firstInput)) {
      _logEvent(analytic);
    }
    _firstInput = analytic;
  }

  /// Sends an [AnalyticType.increment] and provides the appropriate [Analytics].
  void increment({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.increment,
        ),
      );

  /// Sends an [AnalyticType.decrement] and provides the appropriate [Analytics].
  void decrement({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.decrement,
        ),
      );

  /// Sends an [AnalyticType.accept] and provides the appropriate [Analytics].
  void accept({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.accept,
        ),
      );

  /// Sends an [AnalyticType.decline] and provides the appropriate [Analytics].
  void decline({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.decline,
        ),
      );

  /// Sends an [AnalyticType.scroll] and provides the appropriate [Analytics].
  void scroll({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.scroll,
        ),
      );

  /// Sends an [AnalyticType.start] and provides the appropriate [Analytics].
  void start({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.start,
        ),
      );

  /// Sends an [AnalyticType.stop] and provides the appropriate [Analytics].
  void stop({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticType.stop,
        ),
      );

  /// Sends the current screen and provides the appropriate [Analytics].
  void screen({
    required String Function(A analytics) subject,
  }) {
    final name = subject(_analyticsData);
    _analyticsImplementation?.setCurrentScreen(name: name);
    _loglytics?.logAnalytic(name: name);
  }

  /// Resets all current analytics data.
  Future<void> reset() async => _analyticsImplementation?.resetAnalyticsData();

  /// Resets the [_firstInput] used by [AnalyticsService.input].
  void resetFirstInput() => _firstInput = null;

  /// Main method used for sending any [analytic] in this class.
  void _logEvent(Analytic analytic) {
    final name = analytic.name;
    final parameters = analytic.parameters;
    _analyticsImplementation?.logEvent(name: name, parameters: parameters);
    _loglytics?.logAnalytic(name: name, parameters: parameters);
  }
}
