import '../../loglytics.dart';
import '../loglytics/loglytics.dart';
import 'analytic.dart';
import 'analytics_interface.dart';

/// Used to provide an easy interface for sending analytics.
///
/// Each [AnalyticsTypes] has its own method that exposes implementations of predefined [Analytics].
/// For example you can use [AnalyticsService.tapped] and it will automatically provide you with the
/// proper [Analytics] and a '_tapped' event.
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

  /// Provides a callback to send a [CustomAnalytic] while providing your [Analytics] implementation.
  ///
  /// This method should be used when you decide to specify your analytics not per subject, but per
  /// specific methods. Each of your methods should return a [CustomAnalytic]. Whenever you would
  /// want to access your specific methods you should call this [event] method and they will be
  /// provided to you through the callback that exposes your [Analytics] implementation.
  void event({required CustomAnalytic Function(A analytics) analytic}) =>
      _logCustomEvent(analytic(_analyticsData));

  /// Sends an [AnalyticsTypes.tapped] and provides the appropriate [Analytics].
  void tapped({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.tapped,
        ),
      );

  /// Sends an [AnalyticsTypes.clicked] and provides the appropriate [Analytics].
  void clicked({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.clicked,
        ),
      );

  /// Sends an [AnalyticsTypes.focussed] and provides the appropriate [Analytics].
  void focussed({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.focussed,
        ),
      );

  /// Sends an [AnalyticsTypes.selected] and provides the appropriate [Analytics].
  void selected({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.selected,
        ),
      );

  /// Sends an [AnalyticsTypes.connected] and provides the appropriate [Analytics].
  void connected({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.connected,
        ),
      );

  /// Sends an [AnalyticsTypes.disconnected] and provides the appropriate [Analytics].
  void disconnected({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.disconnected,
        ),
      );

  /// Sends an [AnalyticsTypes.viewed] and provides the appropriate [Analytics].
  void viewed({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.viewed,
        ),
      );

  /// Sends an [AnalyticsTypes.hidden] and provides the appropriate [Analytics].
  void hidden({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.hidden,
        ),
      );

  /// Sends an [AnalyticsTypes.opened] and provides the appropriate [Analytics].
  void opened({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.opened,
        ),
      );

  /// Sends an [AnalyticsTypes.closed] and provides the appropriate [Analytics].
  void closed({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.closed,
        ),
      );

  /// Sends an [AnalyticsTypes.failed] and provides the appropriate [Analytics].
  void failed({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.failed,
        ),
      );

  /// Sends an [AnalyticsTypes.succeeded] and provides the appropriate [Analytics].
  void succeeded({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.succeeded,
        ),
      );

  /// Sends an [AnalyticsTypes.sent] and provides the appropriate [Analytics].
  void sent({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.sent,
        ),
      );

  /// Sends an [AnalyticsTypes.received] and provides the appropriate [Analytics].
  void received({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.received,
        ),
      );

  /// Sends an [AnalyticsTypes.validated] and provides the appropriate [Analytics].
  void validated({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.validated,
        ),
      );

  /// Sends an [AnalyticsTypes.invalidated] and provides the appropriate [Analytics].
  void invalidated({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.invalidated,
        ),
      );

  /// Sends an [AnalyticsTypes.searched] and provides the appropriate [Analytics].
  void searched({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.searched,
        ),
      );

  /// Sends an [AnalyticsTypes.liked] and provides the appropriate [Analytics].
  void liked({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.liked,
        ),
      );

  /// Sends an [AnalyticsTypes.shared] and provides the appropriate [Analytics].
  void shared({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.shared,
        ),
      );

  /// Sends an [AnalyticsTypes.commented] and provides the appropriate [Analytics].
  void commented({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.commented,
        ),
      );

  /// Sends an [AnalyticsTypes.input] and provides the appropriate [Analytics].
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
      type: AnalyticsTypes.input,
    );
    if (_firstInput == null || !onlyFirstValue || !analytic.equals(_firstInput)) {
      _logEvent(analytic);
    }
    _firstInput = analytic;
  }

  /// Sends an [AnalyticsTypes.incremented] and provides the appropriate [Analytics].
  void incremented({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.incremented,
        ),
      );

  /// Sends an [AnalyticsTypes.decremented] and provides the appropriate [Analytics].
  void decremented({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.decremented,
        ),
      );

  /// Sends an [AnalyticsTypes.accepted] and provides the appropriate [Analytics].
  void accepted({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.accepted,
        ),
      );

  /// Sends an [AnalyticsTypes.declined] and provides the appropriate [Analytics].
  void declined({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.declined,
        ),
      );

  /// Sends an [AnalyticsTypes.alert] and provides the appropriate [Analytics].
  void alert({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.alert,
        ),
      );

  /// Sends an [AnalyticsTypes.scrolled] and provides the appropriate [Analytics].
  void scrolled({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.scrolled,
        ),
      );

  /// Sends an [AnalyticsTypes.started] and provides the appropriate [Analytics].
  void started({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.started,
        ),
      );

  /// Sends an [AnalyticsTypes.stopped] and provides the appropriate [Analytics].
  void stopped({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.stopped,
        ),
      );

  /// Sends an [AnalyticsTypes.initialised] and provides the appropriate [Analytics].
  void initialised({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.initialised,
        ),
      );

  /// Sends an [AnalyticsTypes.disposed] and provides the appropriate [Analytics].
  void disposed({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.disposed,
        ),
      );

  /// Sends an [AnalyticsTypes.fetched] and provides the appropriate [Analytics].
  void fetched({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.fetched,
        ),
      );

  /// Sends an [AnalyticsTypes.set] and provides the appropriate [Analytics].
  void set({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.set,
        ),
      );

  /// Sends an [AnalyticsTypes.get] and provides the appropriate [Analytics].
  void get({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.get,
        ),
      );

  /// Sends an [AnalyticsTypes.foreground] and provides the appropriate [Analytics].
  void foreground({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.foreground,
        ),
      );

  /// Sends an [AnalyticsTypes.background] and provides the appropriate [Analytics].
  void background({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.background,
        ),
      );

  /// Sends an [AnalyticsTypes.purchased] and provides the appropriate [Analytics].
  void purchased({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.purchased,
        ),
      );

  /// Sends an [AnalyticsTypes.dismissed] and provides the appropriate [Analytics].
  void dismissed({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.dismissed,
        ),
      );

  /// Sends an [AnalyticsTypes.upgraded] and provides the appropriate [Analytics].
  void upgraded({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.upgraded,
        ),
      );

  /// Sends an [AnalyticsTypes.downgraded] and provides the appropriate [Analytics].
  void downgraded({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.downgraded,
        ),
      );

  /// Sends an [AnalyticsTypes.interaction] and provides the appropriate [Analytics].
  void interaction({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.interaction,
        ),
      );

  /// Sends an [AnalyticsTypes.query] and provides the appropriate [Analytics].
  void query({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.query,
        ),
      );

  /// Sends an [AnalyticsTypes.confirmed] and provides the appropriate [Analytics].
  void confirmed({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.confirmed,
        ),
      );

  /// Sends an [AnalyticsTypes.canceled] and provides the appropriate [Analytics].
  void canceled({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.canceled,
        ),
      );

  /// Sends an [AnalyticsTypes.created] and provides the appropriate [Analytics].
  void created({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.created,
        ),
      );

  /// Sends an [AnalyticsTypes.read] and provides the appropriate [Analytics].
  void read({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.read,
        ),
      );

  /// Sends an [AnalyticsTypes.updated] and provides the appropriate [Analytics].
  void updated({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.updated,
        ),
      );

  /// Sends an [AnalyticsTypes.deleted] and provides the appropriate [Analytics].
  void deleted({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.deleted,
        ),
      );

  /// Sends an [AnalyticsTypes.added] and provides the appropriate [Analytics].
  void added({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.added,
        ),
      );

  /// Sends an [AnalyticsTypes.removed] and provides the appropriate [Analytics].
  void removed({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.removed,
        ),
      );

  /// Sends an [AnalyticsTypes.subscribed] and provides the appropriate [Analytics].
  void subscribed({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.subscribed,
        ),
      );

  /// Sends an [AnalyticsTypes.unsubscribed] and provides the appropriate [Analytics].
  void unsubscribed({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.unsubscribed,
        ),
      );

  /// Sends an [AnalyticsTypes.changed] and provides the appropriate [Analytics].
  void changed({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.changed,
        ),
      );

  /// Sends an [AnalyticsTypes.denied] and provides the appropriate [Analytics].
  void denied({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.denied,
        ),
      );

  /// Sends an [AnalyticsTypes.skipped] and provides the appropriate [Analytics].
  void skipped({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.skipped,
        ),
      );

  /// Sends an [AnalyticsTypes.checked] and provides the appropriate [Analytics].
  void checked({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.checked,
        ),
      );

  /// Sends an [AnalyticsTypes.unchecked] and provides the appropriate [Analytics].
  void unchecked({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.unchecked,
        ),
      );

  /// Sends an [AnalyticsTypes.attempted] and provides the appropriate [Analytics].
  void attempted({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.attempted,
        ),
      );

  /// Sends an [AnalyticsTypes.reset] and provides the appropriate [Analytics].
  void reset({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.reset,
        ),
      );

  /// Sends an [AnalyticsTypes.enabled] and provides the appropriate [Analytics].
  void enabled({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.enabled,
        ),
      );

  /// Sends an [AnalyticsTypes.disabled] and provides the appropriate [Analytics].
  void disabled({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.disabled,
        ),
      );

  /// Sends an [AnalyticsTypes.began] and provides the appropriate [Analytics].
  void began({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.began,
        ),
      );

  /// Sends an [AnalyticsTypes.ended] and provides the appropriate [Analytics].
  void ended({
    required String Function(A analytics) subject,
    Map<String, Object?>? Function(A analytics)? parameters,
  }) =>
      _logEvent(
        Analytic(
          subject: subject(_analyticsData),
          parameters: parameters?.call(_analyticsData),
          type: AnalyticsTypes.ended,
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
  Future<void> resetAnalytics() async => _analyticsImplementation?.resetAnalyticsData();

  /// Resets the [_firstInput] used by [AnalyticsService.input].
  void resetFirstInput() => _firstInput = null;

  /// Main method used for sending any [analytic] in this class.
  void _logEvent(Analytic analytic) {
    final name = analytic.name;
    final parameters = analytic.parameters;
    _analyticsImplementation?.logEvent(name: name, parameters: parameters);
    _loglytics?.logAnalytic(name: name, parameters: parameters);
  }

  /// Alternate method used for sending [CustomAnalytic]s.
  void _logCustomEvent(CustomAnalytic customAnalytic) {
    final name = customAnalytic.name;
    final parameters = customAnalytic.parameters;
    _analyticsImplementation?.logEvent(name: name, parameters: parameters);
    _loglytics?.logAnalytic(name: name, parameters: parameters);
  }
}
