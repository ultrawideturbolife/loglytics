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
  none,
}

/// Used to generate the proper String format when sending analytics to the analytics provider.
extension AnalyticsTypesHelpers on AnalyticsTypes {
  String get name {
    switch (this) {
      case AnalyticsTypes.event:
        return 'event';
      case AnalyticsTypes.tapped:
        return 'tapped';
      case AnalyticsTypes.clicked:
        return 'clicked';
      case AnalyticsTypes.focussed:
        return 'focussed';
      case AnalyticsTypes.selected:
        return 'selected';
      case AnalyticsTypes.connected:
        return 'connected';
      case AnalyticsTypes.disconnected:
        return 'disconnected';
      case AnalyticsTypes.viewed:
        return 'viewed';
      case AnalyticsTypes.hidden:
        return 'hidden';
      case AnalyticsTypes.opened:
        return 'opened';
      case AnalyticsTypes.closed:
        return 'closed';
      case AnalyticsTypes.failed:
        return 'failed';
      case AnalyticsTypes.succeeded:
        return 'succeeded';
      case AnalyticsTypes.sent:
        return 'sent';
      case AnalyticsTypes.received:
        return 'received';
      case AnalyticsTypes.validated:
        return 'validated';
      case AnalyticsTypes.invalidated:
        return 'invalidated';
      case AnalyticsTypes.searched:
        return 'searched';
      case AnalyticsTypes.liked:
        return 'liked';
      case AnalyticsTypes.shared:
        return 'shared';
      case AnalyticsTypes.commented:
        return 'commented';
      case AnalyticsTypes.input:
        return 'input';
      case AnalyticsTypes.incremented:
        return 'incremented';
      case AnalyticsTypes.decremented:
        return 'decremented';
      case AnalyticsTypes.accepted:
        return 'accepted';
      case AnalyticsTypes.declined:
        return 'declined';
      case AnalyticsTypes.alert:
        return 'alert';
      case AnalyticsTypes.scrolled:
        return 'scrolled';
      case AnalyticsTypes.started:
        return 'started';
      case AnalyticsTypes.stopped:
        return 'stopped';
      case AnalyticsTypes.initialised:
        return 'initialised';
      case AnalyticsTypes.disposed:
        return 'disposed';
      case AnalyticsTypes.fetched:
        return 'fetched';
      case AnalyticsTypes.set:
        return 'set';
      case AnalyticsTypes.get:
        return 'get';
      case AnalyticsTypes.foreground:
        return 'foreground';
      case AnalyticsTypes.background:
        return 'background';
      case AnalyticsTypes.purchased:
        return 'purchased';
      case AnalyticsTypes.dismissed:
        return 'dismissed';
      case AnalyticsTypes.upgraded:
        return 'upgraded';
      case AnalyticsTypes.downgraded:
        return 'downgraded';
      case AnalyticsTypes.interaction:
        return 'interaction';
      case AnalyticsTypes.query:
        return 'query';
      case AnalyticsTypes.confirmed:
        return 'confirmed';
      case AnalyticsTypes.canceled:
        return 'canceled';
      case AnalyticsTypes.created:
        return 'created';
      case AnalyticsTypes.read:
        return 'read';
      case AnalyticsTypes.updated:
        return 'updated';
      case AnalyticsTypes.deleted:
        return 'deleted';
      case AnalyticsTypes.added:
        return 'added';
      case AnalyticsTypes.removed:
        return 'removed';
      case AnalyticsTypes.subscribed:
        return 'subscribed';
      case AnalyticsTypes.unsubscribed:
        return 'unsubscribed';
      case AnalyticsTypes.changed:
        return 'changed';
      case AnalyticsTypes.denied:
        return 'denied';
      case AnalyticsTypes.skipped:
        return 'skipped';
      case AnalyticsTypes.checked:
        return 'checked';
      case AnalyticsTypes.unchecked:
        return 'unchecked';
      case AnalyticsTypes.attempted:
        return 'attempted';
      case AnalyticsTypes.reset:
        return 'reset';
      case AnalyticsTypes.enabled:
        return 'enabled';
      case AnalyticsTypes.disabled:
        return 'disabled';
      case AnalyticsTypes.began:
        return 'began';
      case AnalyticsTypes.ended:
        return 'ended';
      case AnalyticsTypes.refreshed:
        return 'refreshed';
        break;
      case AnalyticsTypes.none:
        return '';
    }
  }

  /// Used to generate [CustomAnalytic] objects based on [AnalyticsTypes].
  CustomAnalytic toCustomAnalytic({required String subject, Map<String, Object?>? parameters}) =>
      Analytic(subject: subject, type: this, parameters: parameters).toCustomAnalytic;
}
