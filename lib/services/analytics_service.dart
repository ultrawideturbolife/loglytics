// @dart = 2.12

import 'package:loglytics/analytics/analytic.dart';
import 'package:loglytics/analytics/analytics.dart';
import 'package:loglytics/analytics/analytics_interface.dart';
import 'package:loglytics/crashlytics/crashlytics_interface.dart';
import 'package:loglytics/services/log_service.dart';

class AnalyticsService<S extends AnalyticsSubjects, P extends AnalyticsParameters> {
  AnalyticsService({
    required S analyticsSubjects,
    required P analyticsParameters,
    LogService? logService,
    AnalyticsInterface? analyticsImplementation,
    CrashlyticsInterface? crashlyticsImplementation,
  })  : _analyticsSubjects = analyticsSubjects,
        _analyticsParameters = analyticsParameters,
        _logService = logService,
        _analyticsImplementation = analyticsImplementation,
        _crashlyticsImplementation = crashlyticsImplementation;

  final S _analyticsSubjects;
  final P _analyticsParameters;

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
    final name = property(_analyticsSubjects);
    final _value = value?.toString() ?? '-';
    _analyticsImplementation?.setUserProperty(name: name, value: _value);
    _crashlyticsImplementation?.setCustomKey(name, _value);
    _logService?.logAnalytic(name: name, value: _value);
  }

  void event({required Analytic Function(S subjects, P parameters) analytic}) =>
      _logEvent(analytic(_analyticsSubjects, _analyticsParameters));

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

  void unFocus({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.unFocus,
        ),
      );

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

  void create({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.create,
        ),
      );

  void update({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.update,
        ),
      );

  void delete({
    required String Function(S subjects) subject,
    Map<String, Object?>? Function(P parameters)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsSubjects),
          parameters: parameters?.call(_analyticsParameters),
          type: AnalyticType.delete,
        ),
      );

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

  void screen({
    required String Function(S subjects) subject,
  }) {
    final analytic = Analytic(
      subject: subject(_analyticsSubjects),
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
