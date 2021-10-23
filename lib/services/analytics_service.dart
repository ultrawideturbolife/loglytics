import 'package:loglytics/analytics/analytic.dart';
import 'package:loglytics/analytics/analytics_interface.dart';
import 'package:loglytics/analytics/feature_analytics.dart';
import 'package:loglytics/crashlytics/crashlytics_interface.dart';
import 'package:loglytics/services/log_service.dart';

class AnalyticsService<S extends FeatureSubjects, P extends FeatureParameters> {
  AnalyticsService({
    required S featureSubjects,
    required P featureParameters,
    LogService? logService,
    AnalyticsInterface? analyticsImplementation,
    CrashlyticsInterface? crashlyticsImplementation,
  })  : _featureSubjects = featureSubjects,
        _featureParameters = featureParameters,
        _logService = logService,
        _analyticsImplementation = analyticsImplementation,
        _crashlyticsImplementation = crashlyticsImplementation;

  final S _featureSubjects;
  final P _featureParameters;

  final LogService? _logService;
  final AnalyticsInterface? _analyticsImplementation;
  final CrashlyticsInterface? _crashlyticsImplementation;

  Analytic? _firstInput;

  void userId({required String userId}) {
    _analyticsImplementation?.setUserId(userId);
    _crashlyticsImplementation?.setUserIdentifier(userId);
    _logService?.logAnalytic(name: 'user_id', value: userId);
  }

  void userProperty({required String Function(S subjects) property, required Object? value}) {
    final name = property(_featureSubjects);
    final _value = value?.toString() ?? '-';
    _analyticsImplementation?.setUserProperty(name: name, value: _value);
    _crashlyticsImplementation?.setCustomKey(name, _value);
    _logService?.logAnalytic(name: name, value: _value);
  }

  void event({required Analytic Function(S subjects, P parameters) analytic}) =>
      _logEvent(analytic(_featureSubjects, _featureParameters));

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

  void screen({
    required String Function(S subjects) subject,
  }) {
    final analytic = Analytic(
      subject: subject(_featureSubjects),
      type: AnalyticType.screen,
    );
    _analyticsImplementation?.setCurrentScreen(screenName: analytic.name);
    _logService?.logAnalytic(name: analytic.name);
  }

  Future<void> reset() async => _analyticsImplementation?.resetAnalyticsData();
  void resetFirstInput() async => _firstInput = null;

  void _logEvent(Analytic analytic) {
    final name = analytic.name;
    final parameters = analytic.parameters;
    _analyticsImplementation?.logEvent(name: name, parameters: parameters);
    _logService?.logAnalytic(name: name, parameters: parameters);
  }
}
