import 'package:loglytics/src/loglytics/loglytics_data.dart';

import '../../loglytics.dart';
import '../loglytics/loglytics.dart';
import 'analytic.dart';
import 'analytics_interface.dart';

/// Used to provide an easy interface for sending analytics.
///
/// Each [AnalyticType] has its own method that exposes implementations of predefined
/// [LoglyticsData].
/// example you can use [AnalyticsService.tap] and it the will automatically provide you with the
/// proper [LoglyticsData].
class AnalyticsService<D extends LoglyticsData> {
  AnalyticsService({
    required D loglyticsData,
    Loglytics? loglytics,
    AnalyticsInterface? analyticsImplementation,
    CrashReportsInterface? crashReportsImplementation,
  })  : _loglyticsData = loglyticsData,
        _loglytics = loglytics,
        _analyticsImplementation = analyticsImplementation,
        _crashReportsImplementation = crashReportsImplementation;

  final D _loglyticsData;

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
  void userProperty({required String Function(D data) property, required Object? value}) {
    final name = property(_loglyticsData);
    final _value = value?.toString() ?? '-';
    _analyticsImplementation?.setUserProperty(name: name, value: _value);
    _crashReportsImplementation?.setCustomKey(name, _value);
    _loglytics?.logAnalytic(name: name, value: _value);
  }

  /// Sends a custom analytic event by providing both [LoglyticsData].
  ///
  /// This method may be used to log anything that is not covered by any other method in this class
  /// and expects an [Analytic] in return from the [analytic] callback.
  void event({required Analytic Function(D data) analytic}) => _logEvent(analytic(_loglyticsData));

  /// Sends an [AnalyticType.tap] and provides the appropriate [LoglyticsData].
  void tap({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.tap,
        ),
      );

  /// Sends an [AnalyticType.click] and provides the appropriate [LoglyticsData].
  void click({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.click,
        ),
      );

  /// Sends an [AnalyticType.focus] and provides the appropriate [LoglyticsData].
  void focus({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.focus,
        ),
      );

  /// Sends an [AnalyticType.select] and provides the appropriate [LoglyticsData].
  void select({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.select,
        ),
      );

  /// Sends an [AnalyticType.connect] and provides the appropriate [LoglyticsData].
  void connect({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.connect,
        ),
      );

  /// Sends an [AnalyticType.connect] and provides the appropriate [LoglyticsData].
  void disconnect({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.connect,
        ),
      );

  /// Sends an [AnalyticType.view] and provides the appropriate [LoglyticsData].
  void view({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.view,
        ),
      );

  /// Sends an [AnalyticType.hide] and provides the appropriate [LoglyticsData].
  void hide({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.hide,
        ),
      );

  /// Sends an [AnalyticType.open] and provides the appropriate [LoglyticsData].
  void open({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.open,
        ),
      );

  /// Sends an [AnalyticType.close] and provides the appropriate [LoglyticsData].
  void close({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.close,
        ),
      );

  /// Sends an [AnalyticType.fail] and provides the appropriate [LoglyticsData].
  void fail({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.fail,
        ),
      );

  /// Sends an [AnalyticType.success] and provides the appropriate [LoglyticsData].
  void success({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.success,
        ),
      );

  /// Sends an [AnalyticType.send] and provides the appropriate [LoglyticsData].
  void send({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.send,
        ),
      );

  /// Sends an [AnalyticType.receive] and provides the appropriate [LoglyticsData].
  void receive({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.receive,
        ),
      );

  /// Sends an [AnalyticType.valid] and provides the appropriate [LoglyticsData].
  void valid({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.valid,
        ),
      );

  /// Sends an [AnalyticType.invalid] and provides the appropriate [LoglyticsData].
  void invalid({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.invalid,
        ),
      );

  /// Sends an [AnalyticType.search] and provides the appropriate [LoglyticsData].
  void search({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.search,
        ),
      );

  /// Sends an [AnalyticType.like] and provides the appropriate [LoglyticsData].
  void like({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.like,
        ),
      );

  /// Sends an [AnalyticType.share] and provides the appropriate [LoglyticsData].
  void share({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.share,
        ),
      );

  /// Sends an [AnalyticType.comment] and provides the appropriate [LoglyticsData].
  void comment({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.comment,
        ),
      );

  /// Sends an [AnalyticType.input] and provides the appropriate [LoglyticsData].
  ///
  /// Defaults to only sending the first analytic by settings [onlyFirstValue] to true.
  void input({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
    bool onlyFirstValue = true,
  }) {
    final analytic = Analytic(
      subject: subject(_loglyticsData),
      parameters: parameters?.call(_loglyticsData),
      type: AnalyticType.input,
    );
    if (_firstInput == null || !onlyFirstValue || !analytic.equals(_firstInput)) {
      _logEvent(analytic);
    }
    _firstInput = analytic;
  }

  /// Sends an [AnalyticType.increment] and provides the appropriate [LoglyticsData].
  void increment({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.increment,
        ),
      );

  /// Sends an [AnalyticType.decrement] and provides the appropriate [LoglyticsData].
  void decrement({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.decrement,
        ),
      );

  /// Sends an [AnalyticType.accept] and provides the appropriate [LoglyticsData].
  void accept({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.accept,
        ),
      );

  /// Sends an [AnalyticType.decline] and provides the appropriate [LoglyticsData].
  void decline({
    required String Function(D data) subject,
    Map<String, Object?>? Function(D data)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_loglyticsData),
          parameters: parameters?.call(_loglyticsData),
          type: AnalyticType.decline,
        ),
      );

  /// Sends the current screen and provides the appropriate [LoglyticsData].
  void screen({
    required String Function(D data) subject,
  }) {
    final name = subject(_loglyticsData);
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
