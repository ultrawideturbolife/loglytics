import 'package:loglytics/loglytics.dart';

/// Every action or state that's applicable to data from your [Analytics] implementations.
enum AnalyticsTypes {
  event,
  tapped,
  clicked,
  focussed,
  selected,
  connected,
  disconnected,
  viewed,
  hidden,
  opened,
  closed,
  failed,
  succeeded,
  sent,
  received,
  validated,
  invalidated,
  searched,
  liked,
  shared,
  commented,
  input,
  incremented,
  decremented,
  accepted,
  declined,
  alert,
  scrolled,
  started,
  stopped,
  initialised,
  disposed,
  fetched,
  set,
  get,
  foreground,
  background,
  purchased,
  dismissed,
  upgraded,
  downgraded,
  interaction,
  query,
  confirmed,
  canceled,
  created,
  read,
  updated,
  deleted,
  added,
  removed,
  subscribed,
  unsubscribed,
  changed,
  denied,
  skipped,
  checked,
  unchecked,
  attempted,
  reset,
  enabled,
  disabled,
  began,
  ended,
  refreshed,
  generated,
  unsupported,
  invalid,
  valid,
  shown,
  loaded,
  saved,
  found,
  completed,
  error,
  given,
  notFound,
  taken,
  snoozed,
  verified,
  swiped,
  used,
  filled,
  cleared,
  unverified,
  paused,
  resumed,
  linked,
  unlinked,
  requested,
  pressed,
  none,
}

/// Used to generate the proper String format when sending analytics to the analytics provider.
extension AnalyticsTypesHelpers on AnalyticsTypes {
  String get value {
    switch (this) {
      case AnalyticsTypes.event:
      case AnalyticsTypes.tapped:
      case AnalyticsTypes.clicked:
      case AnalyticsTypes.focussed:
      case AnalyticsTypes.selected:
      case AnalyticsTypes.connected:
      case AnalyticsTypes.disconnected:
      case AnalyticsTypes.viewed:
      case AnalyticsTypes.hidden:
      case AnalyticsTypes.opened:
      case AnalyticsTypes.closed:
      case AnalyticsTypes.failed:
      case AnalyticsTypes.succeeded:
      case AnalyticsTypes.sent:
      case AnalyticsTypes.received:
      case AnalyticsTypes.validated:
      case AnalyticsTypes.invalidated:
      case AnalyticsTypes.searched:
      case AnalyticsTypes.liked:
      case AnalyticsTypes.shared:
      case AnalyticsTypes.commented:
      case AnalyticsTypes.input:
      case AnalyticsTypes.incremented:
      case AnalyticsTypes.decremented:
      case AnalyticsTypes.accepted:
      case AnalyticsTypes.declined:
      case AnalyticsTypes.alert:
      case AnalyticsTypes.scrolled:
      case AnalyticsTypes.started:
      case AnalyticsTypes.stopped:
      case AnalyticsTypes.initialised:
      case AnalyticsTypes.disposed:
      case AnalyticsTypes.fetched:
      case AnalyticsTypes.set:
      case AnalyticsTypes.get:
      case AnalyticsTypes.foreground:
      case AnalyticsTypes.background:
      case AnalyticsTypes.purchased:
      case AnalyticsTypes.dismissed:
      case AnalyticsTypes.upgraded:
      case AnalyticsTypes.downgraded:
      case AnalyticsTypes.interaction:
      case AnalyticsTypes.query:
      case AnalyticsTypes.confirmed:
      case AnalyticsTypes.canceled:
      case AnalyticsTypes.created:
      case AnalyticsTypes.read:
      case AnalyticsTypes.updated:
      case AnalyticsTypes.deleted:
      case AnalyticsTypes.added:
      case AnalyticsTypes.removed:
      case AnalyticsTypes.subscribed:
      case AnalyticsTypes.unsubscribed:
      case AnalyticsTypes.changed:
      case AnalyticsTypes.denied:
      case AnalyticsTypes.skipped:
      case AnalyticsTypes.checked:
      case AnalyticsTypes.unchecked:
      case AnalyticsTypes.attempted:
      case AnalyticsTypes.reset:
      case AnalyticsTypes.enabled:
      case AnalyticsTypes.disabled:
      case AnalyticsTypes.began:
      case AnalyticsTypes.ended:
      case AnalyticsTypes.refreshed:
      case AnalyticsTypes.generated:
      case AnalyticsTypes.unsupported:
      case AnalyticsTypes.invalid:
      case AnalyticsTypes.valid:
      case AnalyticsTypes.shown:
      case AnalyticsTypes.loaded:
      case AnalyticsTypes.saved:
      case AnalyticsTypes.found:
      case AnalyticsTypes.completed:
      case AnalyticsTypes.error:
      case AnalyticsTypes.taken:
      case AnalyticsTypes.given:
      case AnalyticsTypes.snoozed:
      case AnalyticsTypes.verified:
      case AnalyticsTypes.swiped:
      case AnalyticsTypes.used:
      case AnalyticsTypes.filled:
      case AnalyticsTypes.cleared:
      case AnalyticsTypes.unverified:
      case AnalyticsTypes.paused:
      case AnalyticsTypes.resumed:
      case AnalyticsTypes.linked:
      case AnalyticsTypes.unlinked:
      case AnalyticsTypes.requested:
      case AnalyticsTypes.pressed:
        return name;
      case AnalyticsTypes.notFound:
        return 'not_found';
      case AnalyticsTypes.none:
        return '';
    }
  }

  /// Used to generate [CustomAnalytic] objects based on [AnalyticsTypes].
  CustomAnalytic toCustomAnalytic({
    required String subject,
    Map<String, Object>? parameters,
  }) =>
      Analytic(subject: subject, type: this, parameters: parameters)
          .toCustomAnalytic;
}
