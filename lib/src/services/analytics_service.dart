import '../analytics/analytic.dart';
import '../analytics/analytics_interface.dart';
import '../analytics/analytics_wrapper.dart';
import '../crashlytics/crash_reports_interface.dart';
import 'loglytics.dart';

/// Used to provide an easy interface for sending analytics.
///
/// Each [AnalyticType] has its own method that exposes implementations of predefined
/// [AnalyticsSubjects] and [AnalyticsParameters]. When wanting to register an [AnalyticType.tap] for
/// example you can use [AnalyticsService.tap] and it the will automatically provide you with the
/// proper [AnalyticsSubjects] and [AnalyticsParameters] that the tap could relate to.
class AnalyticsService<S extends AnalyticsSubjects, P extends AnalyticsParameters> {
  AnalyticsService({
    required S analyticsSubjects,
    required P analyticsParameters,
    Loglytics? loglytics,
    AnalyticsInterface? analyticsImplementation,
    CrashReportsInterface? crashReportsImplementation,
  })  : _analyticsSubjects = analyticsSubjects,
        _analyticsParameters = analyticsParameters,
        _loglytics = loglytics,
        _analyticsImplementation = analyticsImplementation,
        _crashReportsImplementation = crashReportsImplementation;

  final S _analyticsSubjects;
  final P _analyticsParameters;

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
  void userProperty({required String Function(S subjects) property, required Object? value}) {
    final name = property(_analyticsSubjects);
    final _value = value?.toString() ?? '-';
    _analyticsImplementation?.setUserProperty(name: name, value: _value);
    _crashReportsImplementation?.setCustomKey(name, _value);
    _loglytics?.logAnalytic(name: name, value: _value);
  }

  /// Sends a custom analytic event by providing both [AnalyticsSubjects] and [AnalyticsParameters].
  ///
  /// This method may be used to log anything that is not covered by any other method in this class
  /// and expects an [Analytic] in return from the [analytic] callback.
  void event({required Analytic Function(S subjects, P parameters) analytic}) =>
      _logEvent(analytic(_analyticsSubjects, _analyticsParameters));

  /// Sends an [AnalyticType.tap] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void tap({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.tap,
        ),
      );

  /// Sends an [AnalyticType.click] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void click({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.click,
        ),
      );

  /// Sends an [AnalyticType.focus] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void focus({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.focus,
        ),
      );

  /// Sends an [AnalyticType.select] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void select({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.select,
        ),
      );

  /// Sends an [AnalyticType.connect] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void connect({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.connect,
        ),
      );

  /// Sends an [AnalyticType.connect] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void disconnect({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.connect,
        ),
      );

  /// Sends an [AnalyticType.view] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void view({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.view,
        ),
      );

  /// Sends an [AnalyticType.hide] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void hide({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.hide,
        ),
      );

  /// Sends an [AnalyticType.open] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void open({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.open,
        ),
      );

  /// Sends an [AnalyticType.close] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void close({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.close,
        ),
      );

  /// Sends an [AnalyticType.fail] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void fail({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.fail,
        ),
      );

  /// Sends an [AnalyticType.success] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void success({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.success,
        ),
      );

  /// Sends an [AnalyticType.send] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void send({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.send,
        ),
      );

  /// Sends an [AnalyticType.receive] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void receive({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.receive,
        ),
      );

  /// Sends an [AnalyticType.valid] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void valid({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.valid,
        ),
      );

  /// Sends an [AnalyticType.invalid] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void invalid({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.invalid,
        ),
      );

  /// Sends an [AnalyticType.search] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void search({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.search,
        ),
      );

  /// Sends an [AnalyticType.like] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void like({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.like,
        ),
      );

  /// Sends an [AnalyticType.share] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void share({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.share,
        ),
      );

  /// Sends an [AnalyticType.comment] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void comment({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.comment,
        ),
      );

  /// Sends an [AnalyticType.input] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  ///
  /// Defaults to only sending the first analytic by settings [onlyFirstValue] to true.
  void input({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
    bool onlyFirstValue = true,
  }) {
    final analytic = Analytic(
      subject: subject(_analyticsSubjects),
      parameters: parameters?.call(_analyticsParameters),
      type: AnalyticType.input,
    );
    if (_firstInput == null || !onlyFirstValue || !analytic.equals(_firstInput)) {
      _logEvent(analytic);
    }
    _firstInput = analytic;
  }

  /// Sends an [AnalyticType.increment] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void increment({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.increment,
        ),
      );

  /// Sends an [AnalyticType.decrement] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void decrement({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.decrement,
        ),
      );

  /// Sends an [AnalyticType.accept] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void accept({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.accept,
        ),
      );

  /// Sends an [AnalyticType.decline] and provides the appropriate [AnalyticsSubjects] and optional [AnalyticsParameters].
  void decline({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.decline,
        ),
      );

  /// Sends the current screen and provides the appropriate [AnalyticsSubjects] where a possible screen name should reside.
  void screen({
    required String Function(S subjects) subject,
  }) {
    final name = subject(_analyticsSubjects);
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
