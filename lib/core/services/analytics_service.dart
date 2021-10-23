// @dart = 2.12

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:loglytics/core/abstract/analytics_strings.dart';
import 'package:loglytics/core/abstract/log_service.dart';
import 'package:loglytics/core/analytics/analytic.dart';

class AnalyticsService<S extends AnalyticsSubjects, P extends AnalyticsParameters> {
  AnalyticsService({
    required S analyticsSubjects,
    required P analyticsParameters,
    LogService? logService,
    FirebaseAnalytics? firebaseAnalytics,
  })  : _analyticsSubjects = analyticsSubjects,
        _analyticsParameters = analyticsParameters,
        _logService = logService,
        _firebaseAnalytics = firebaseAnalytics;

  final S _analyticsSubjects;
  final P _analyticsParameters;

  final LogService? _logService;
  final FirebaseAnalytics? _firebaseAnalytics;

  Analytic? _firstInput;

  void userId({required String userId}) {
    _firebaseAnalytics?.setUserId(userId);
    _logService?.logAnalytic(name: 'user_id', value: userId);
  }

  void userProperty({required String Function(S subjects) property, required Object? value}) {
    final name = property(_analyticsSubjects);
    final _value = value?.toString() ?? '-';
    _firebaseAnalytics?.setUserProperty(name: name, value: _value);
    if (LogService.crashlyticsEnabled) FirebaseCrashlytics.instance.setCustomKey(name, _value);
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
    _firebaseAnalytics?.setCurrentScreen(screenName: analytic.name);
    _logService?.logAnalytic(name: analytic.name);
  }

  Future<void> reset() async => _firebaseAnalytics?.resetAnalyticsData();
  void resetFirstInput() async => _firstInput = null;

  void _logEvent(Analytic analytic) {
    final name = analytic.name;
    final parameters = analytic.parameters;
    _firebaseAnalytics?.logEvent(name: name, parameters: parameters);
    _logService?.logAnalytic(name: name, parameters: parameters);
  }
}
