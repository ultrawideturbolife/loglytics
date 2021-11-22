import '../../loglytics.dart';
import '../loglytics/loglytics.dart';
import 'analytic.dart';
import 'analytics_interface.dart';

/// Used to provide an easy interface for sending analytics.
///
/// Each [AnalyticsTypes] has its own method that exposes implementations of predefined [Analytics].
/// For example you can use [AnalyticsService.tapped] and it will automatically provide you with the
/// proper [Analytics] and a '_tapped' event.
class AnalyticsService {
  AnalyticsService({
    Loglytics? loglytics,
    AnalyticsInterface? analyticsImplementation,
    CrashReportsInterface? crashReportsImplementation,
  })  : _loglytics = loglytics,
        _analyticsImplementation = analyticsImplementation,
        _crashReportsImplementation = crashReportsImplementation;

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
  void userProperty({required String property, required Object? value}) {
    final _value = value?.toString() ?? '';
    if (_value.isNotEmpty) {
      _analyticsImplementation?.setUserProperty(name: property, value: _value);
      _crashReportsImplementation?.setCustomKey(property, _value);
      _loglytics?.logAnalytic(name: property, value: _value);
    } else {
      _loglytics?.logError('Refused setting empty value for $property');
    }
  }

  /// Provides a callback to send a [CustomAnalytic] while providing your [Analytics] implementation.
  ///
  /// This method should be used when you decide to specify your analytics not per subject, but per
  /// specific methods. Each of your methods should return a [CustomAnalytic]. Whenever you would
  /// want to access your specific methods you should call this [event] method and they will be
  /// provided to you through the callback that exposes your [Analytics] implementation.
  void event({required CustomAnalytic customAnalytic}) => _logCustomAnalytic(customAnalytic);

  /// Sends an [AnalyticsTypes.tapped] and provides the appropriate [Analytics].
  void tapped({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.tapped,
        ),
      );

  /// Sends an [AnalyticsTypes.clicked] and provides the appropriate [Analytics].
  void clicked({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.clicked,
        ),
      );

  /// Sends an [AnalyticsTypes.focussed] and provides the appropriate [Analytics].
  void focussed({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.focussed,
        ),
      );

  /// Sends an [AnalyticsTypes.selected] and provides the appropriate [Analytics].
  void selected({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.selected,
        ),
      );

  /// Sends an [AnalyticsTypes.connected] and provides the appropriate [Analytics].
  void connected({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.connected,
        ),
      );

  /// Sends an [AnalyticsTypes.disconnected] and provides the appropriate [Analytics].
  void disconnected({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.disconnected,
        ),
      );

  /// Sends an [AnalyticsTypes.viewed] and provides the appropriate [Analytics].
  void viewed({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.viewed,
        ),
      );

  /// Sends an [AnalyticsTypes.hidden] and provides the appropriate [Analytics].
  void hidden({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.hidden,
        ),
      );

  /// Sends an [AnalyticsTypes.opened] and provides the appropriate [Analytics].
  void opened({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.opened,
        ),
      );

  /// Sends an [AnalyticsTypes.closed] and provides the appropriate [Analytics].
  void closed({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.closed,
        ),
      );

  /// Sends an [AnalyticsTypes.failed] and provides the appropriate [Analytics].
  void failed({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.failed,
        ),
      );

  /// Sends an [AnalyticsTypes.succeeded] and provides the appropriate [Analytics].
  void succeeded({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.succeeded,
        ),
      );

  /// Sends an [AnalyticsTypes.sent] and provides the appropriate [Analytics].
  void sent({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.sent,
        ),
      );

  /// Sends an [AnalyticsTypes.received] and provides the appropriate [Analytics].
  void received({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.received,
        ),
      );

  /// Sends an [AnalyticsTypes.validated] and provides the appropriate [Analytics].
  void validated({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.validated,
        ),
      );

  /// Sends an [AnalyticsTypes.invalidated] and provides the appropriate [Analytics].
  void invalidated({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.invalidated,
        ),
      );

  /// Sends an [AnalyticsTypes.searched] and provides the appropriate [Analytics].
  void searched({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.searched,
        ),
      );

  /// Sends an [AnalyticsTypes.liked] and provides the appropriate [Analytics].
  void liked({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.liked,
        ),
      );

  /// Sends an [AnalyticsTypes.shared] and provides the appropriate [Analytics].
  void shared({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.shared,
        ),
      );

  /// Sends an [AnalyticsTypes.commented] and provides the appropriate [Analytics].
  void commented({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.commented,
        ),
      );

  /// Sends an [AnalyticsTypes.input] and provides the appropriate [Analytics].
  ///
  /// Defaults to only sending the first analytic by settings [onlyFirstValue] to true.
  void input({
    required String subject,
    Map<String, Object?>? parameters,
    bool onlyFirstValue = true,
  }) {
    final analytic = Analytic(
      subject: subject,
      parameters: parameters,
      type: AnalyticsTypes.input,
    );
    if (_firstInput == null || !onlyFirstValue || !analytic.equals(_firstInput)) {
      _logAnalytic(analytic);
    }
    _firstInput = analytic;
  }

  /// Sends an [AnalyticsTypes.incremented] and provides the appropriate [Analytics].
  void incremented({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.incremented,
        ),
      );

  /// Sends an [AnalyticsTypes.decremented] and provides the appropriate [Analytics].
  void decremented({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.decremented,
        ),
      );

  /// Sends an [AnalyticsTypes.accepted] and provides the appropriate [Analytics].
  void accepted({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.accepted,
        ),
      );

  /// Sends an [AnalyticsTypes.declined] and provides the appropriate [Analytics].
  void declined({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.declined,
        ),
      );

  /// Sends an [AnalyticsTypes.alert] and provides the appropriate [Analytics].
  void alert({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.alert,
        ),
      );

  /// Sends an [AnalyticsTypes.scrolled] and provides the appropriate [Analytics].
  void scrolled({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.scrolled,
        ),
      );

  /// Sends an [AnalyticsTypes.started] and provides the appropriate [Analytics].
  void started({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.started,
        ),
      );

  /// Sends an [AnalyticsTypes.stopped] and provides the appropriate [Analytics].
  void stopped({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.stopped,
        ),
      );

  /// Sends an [AnalyticsTypes.initialised] and provides the appropriate [Analytics].
  void initialised({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.initialised,
        ),
      );

  /// Sends an [AnalyticsTypes.disposed] and provides the appropriate [Analytics].
  void disposed({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.disposed,
        ),
      );

  /// Sends an [AnalyticsTypes.fetched] and provides the appropriate [Analytics].
  void fetched({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.fetched,
        ),
      );

  /// Sends an [AnalyticsTypes.set] and provides the appropriate [Analytics].
  void set({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.set,
        ),
      );

  /// Sends an [AnalyticsTypes.get] and provides the appropriate [Analytics].
  void get({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.get,
        ),
      );

  /// Sends an [AnalyticsTypes.foreground] and provides the appropriate [Analytics].
  void foreground({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.foreground,
        ),
      );

  /// Sends an [AnalyticsTypes.background] and provides the appropriate [Analytics].
  void background({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.background,
        ),
      );

  /// Sends an [AnalyticsTypes.purchased] and provides the appropriate [Analytics].
  void purchased({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.purchased,
        ),
      );

  /// Sends an [AnalyticsTypes.dismissed] and provides the appropriate [Analytics].
  void dismissed({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.dismissed,
        ),
      );

  /// Sends an [AnalyticsTypes.upgraded] and provides the appropriate [Analytics].
  void upgraded({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.upgraded,
        ),
      );

  /// Sends an [AnalyticsTypes.downgraded] and provides the appropriate [Analytics].
  void downgraded({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.downgraded,
        ),
      );

  /// Sends an [AnalyticsTypes.interaction] and provides the appropriate [Analytics].
  void interaction({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.interaction,
        ),
      );

  /// Sends an [AnalyticsTypes.query] and provides the appropriate [Analytics].
  void query({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.query,
        ),
      );

  /// Sends an [AnalyticsTypes.confirmed] and provides the appropriate [Analytics].
  void confirmed({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.confirmed,
        ),
      );

  /// Sends an [AnalyticsTypes.canceled] and provides the appropriate [Analytics].
  void canceled({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.canceled,
        ),
      );

  /// Sends an [AnalyticsTypes.created] and provides the appropriate [Analytics].
  void created({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.created,
        ),
      );

  /// Sends an [AnalyticsTypes.read] and provides the appropriate [Analytics].
  void read({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.read,
        ),
      );

  /// Sends an [AnalyticsTypes.updated] and provides the appropriate [Analytics].
  void updated({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.updated,
        ),
      );

  /// Sends an [AnalyticsTypes.deleted] and provides the appropriate [Analytics].
  void deleted({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.deleted,
        ),
      );

  /// Sends an [AnalyticsTypes.added] and provides the appropriate [Analytics].
  void added({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.added,
        ),
      );

  /// Sends an [AnalyticsTypes.removed] and provides the appropriate [Analytics].
  void removed({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.removed,
        ),
      );

  /// Sends an [AnalyticsTypes.subscribed] and provides the appropriate [Analytics].
  void subscribed({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.subscribed,
        ),
      );

  /// Sends an [AnalyticsTypes.unsubscribed] and provides the appropriate [Analytics].
  void unsubscribed({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.unsubscribed,
        ),
      );

  /// Sends an [AnalyticsTypes.changed] and provides the appropriate [Analytics].
  void changed({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.changed,
        ),
      );

  /// Sends an [AnalyticsTypes.denied] and provides the appropriate [Analytics].
  void denied({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.denied,
        ),
      );

  /// Sends an [AnalyticsTypes.skipped] and provides the appropriate [Analytics].
  void skipped({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.skipped,
        ),
      );

  /// Sends an [AnalyticsTypes.checked] and provides the appropriate [Analytics].
  void checked({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.checked,
        ),
      );

  /// Sends an [AnalyticsTypes.unchecked] and provides the appropriate [Analytics].
  void unchecked({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.unchecked,
        ),
      );

  /// Sends an [AnalyticsTypes.attempted] and provides the appropriate [Analytics].
  void attempted({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.attempted,
        ),
      );

  /// Sends an [AnalyticsTypes.reset] and provides the appropriate [Analytics].
  void reset({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.reset,
        ),
      );

  /// Sends an [AnalyticsTypes.enabled] and provides the appropriate [Analytics].
  void enabled({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.enabled,
        ),
      );

  /// Sends an [AnalyticsTypes.disabled] and provides the appropriate [Analytics].
  void disabled({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.disabled,
        ),
      );

  /// Sends an [AnalyticsTypes.began] and provides the appropriate [Analytics].
  void began({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.began,
        ),
      );

  /// Sends an [AnalyticsTypes.ended] and provides the appropriate [Analytics].
  void ended({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.ended,
        ),
      );

  /// Sends an [AnalyticsTypes.refreshed] and provides the appropriate [Analytics].
  void refreshed({
    required String subject,
    Map<String, Object?>? parameters,
  }) =>
      _logAnalytic(
        Analytic(
          subject: subject,
          parameters: parameters,
          type: AnalyticsTypes.refreshed,
        ),
      );

  /// Sends the current screen and provides the appropriate [Analytics].
  void screen({
    required String subject,
  }) {
    final name = subject;
    _analyticsImplementation?.setCurrentScreen(name: name);
    _loglytics?.logAnalytic(name: name);
  }

  /// Resets all current analytics data.
  Future<void> resetAnalytics() async => _analyticsImplementation?.resetAnalyticsData();

  /// Resets the [_firstInput] used by [AnalyticsService.input].
  void resetFirstInput() => _firstInput = null;

  /// Main method used for sending any [analytic] in this class.
  void _logAnalytic(Analytic analytic) {
    final name = analytic.name;
    final parameters = analytic.parameters;
    _analyticsImplementation?.logEvent(name: name, parameters: parameters);
    _loglytics?.logAnalytic(name: name, parameters: parameters);
  }

  /// Alternate method used for sending [CustomAnalytic]s.
  void _logCustomAnalytic(CustomAnalytic customAnalytic) {
    final name = customAnalytic.name;
    final parameters = customAnalytic.parameters;
    _analyticsImplementation?.logEvent(name: name, parameters: parameters);
    _loglytics?.logAnalytic(name: name, parameters: parameters);
  }
}
