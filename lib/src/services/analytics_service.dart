import '../analytics/analytic.dart';
import '../analytics/analytics_interface.dart';
import '../analytics/feature_analytics.dart';
import '../crashlytics/crash_reports_interface.dart';
import 'loglytics.dart';

/// Used to provide an easy interface for sending analytics.
///
/// Each [AnalyticType] has its own method that exposes implementations of predefined
/// [FeatureSubjects] and [FeatureParameters]. When wanting to register an [AnalyticType.tap] for
/// example you can use [AnalyticsService.tap] and it the will automatically provide you with the
/// proper [FeatureSubjects] and [FeatureParameters] that the tap could relate to.
class AnalyticsService<S extends FeatureSubjects, P extends FeatureParameters> {
  AnalyticsService({
    required S featureSubjects,
    required P featureParameters,
    Loglytics? loglytics,
    AnalyticsInterface? analyticsImplementation,
    CrashReportsInterface? crashReportsImplementation,
  })  : _featureSubjects = featureSubjects,
        _featureParameters = featureParameters,
        _loglytics = loglytics,
        _analyticsImplementation = analyticsImplementation,
        _crashReportsImplementation = crashReportsImplementation;

  final S _featureSubjects;
  final P _featureParameters;

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
    final name = property(_featureSubjects);
    final _value = value?.toString() ?? '-';
    _analyticsImplementation?.setUserProperty(name: name, value: _value);
    _crashReportsImplementation?.setCustomKey(name, _value);
    _loglytics?.logAnalytic(name: name, value: _value);
  }

  /// Sends a custom analytic event by providing both [FeatureSubjects] and [FeatureParameters].
  ///
  /// This method may be used to log anything that is not covered by any other method in this class
  /// and expects an [Analytic] in return from the [analytic] callback.
  void event({required Analytic Function(S subjects, P parameters) analytic}) =>
      _logEvent(analytic(_featureSubjects, _featureParameters));

  /// Sends an [AnalyticType.tap] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void tap({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.tap,
        ),
      );

  /// Sends an [AnalyticType.focus] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void focus({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.focus,
        ),
      );

  /// Sends an [AnalyticType.unFocus] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void unFocus({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.unFocus,
        ),
      );

  /// Sends an [AnalyticType.select] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void select({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.select,
        ),
      );

  /// Sends an [AnalyticType.view] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void view({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.view,
        ),
      );

  /// Sends an [AnalyticType.open] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void open({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.open,
        ),
      );

  /// Sends an [AnalyticType.close] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void close({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.close,
        ),
      );

  /// Sends an [AnalyticType.create] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void create({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.create,
        ),
      );

  /// Sends an [AnalyticType.update] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void update({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.update,
        ),
      );

  /// Sends an [AnalyticType.delete] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void delete({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.delete,
        ),
      );

  /// Sends an [AnalyticType.fail] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void fail({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.fail,
        ),
      );

  /// Sends an [AnalyticType.success] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void success({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.success,
        ),
      );

  /// Sends an [AnalyticType.valid] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void valid({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.valid,
        ),
      );

  /// Sends an [AnalyticType.invalid] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void invalid({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.invalid,
        ),
      );

  /// Sends an [AnalyticType.search] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void search({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.search,
        ),
      );

  /// Sends an [AnalyticType.share] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void share({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.share,
        ),
      );

  /// Sends an [AnalyticType.input] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  ///
  /// Defaults to only sending the first analytic by settings [onlyFirstValue] to true.
  void input({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
    bool onlyFirstValue = true,
  }) {
    final analytic = Analytic(
      subject: subject(_featureSubjects),
      parameters: parameters?.call(_featureParameters),
      type: AnalyticType.input,
    );
    if (_firstInput == null || !onlyFirstValue || !analytic.equals(_firstInput)) {
      _logEvent(analytic);
    }
    _firstInput = analytic;
  }

  /// Sends an [AnalyticType.increment] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void increment({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.increment,
        ),
      );

  /// Sends an [AnalyticType.decrement] and provides the appropriate [FeatureSubjects] and optional [FeatureParameters].
  void decrement({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_featureSubjects),
          parameters: parameters?.call(_featureParameters),
          type: AnalyticType.decrement,
        ),
      );

  /// Sends an [AnalyticType.input] and provides the appropriate [FeatureSubjects] where a possible screen name should reside.
  void screen({
    required String Function(S subjects) subject,
  }) {
    final analytic = Analytic(
      subject: subject(_featureSubjects),
      type: AnalyticType.screen,
    );
    _analyticsImplementation?.setCurrentScreen(name: analytic.name);
    _loglytics?.logAnalytic(name: analytic.name);
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
