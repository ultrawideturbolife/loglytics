/// Wrapper class that's used to structure and provide analytics in the [AnalyticsService].
class Analytic {
  const Analytic({
    required String subject,
    required AnalyticType type,
    this.parameters,
  })  : _subject = subject,
        _type = type;

  final String _subject;
  final AnalyticType _type;
  final Map<String, Object?>? parameters;

  String get name => _subject + '_' + _type.name;

  bool equals(Analytic? other) =>
      other != null &&
      (identical(this, other) ||
          runtimeType == other.runtimeType &&
              _subject == other._subject &&
              _type == other._type &&
              parameters == other.parameters);
}

/// Every action or state that's applicable to a subject from [AnalyticsSubjects].
enum AnalyticType {
  event,
  tap,
  click,
  focus,
  select,
  connect,
  disconnect,
  view,
  hide,
  open,
  close,
  fail,
  success,
  send,
  receive,
  valid,
  invalid,
  search,
  like,
  share,
  comment,
  input,
  increment,
  decrement,
  accept,
  decline,
  alert,
}

/// Used to generate the proper String format when sending analytics to the analytics provider.
extension on AnalyticType {
  String get name {
    switch (this) {
      case AnalyticType.event:
        return 'event';
      case AnalyticType.tap:
        return 'tap';
      case AnalyticType.click:
        return 'click';
      case AnalyticType.focus:
        return 'focus';
      case AnalyticType.select:
        return 'select';
      case AnalyticType.connect:
        return 'connect';
      case AnalyticType.disconnect:
        return 'disconnect';
      case AnalyticType.view:
        return 'view';
      case AnalyticType.hide:
        return 'hide';
      case AnalyticType.open:
        return 'open';
      case AnalyticType.close:
        return 'close';
      case AnalyticType.fail:
        return 'fail';
      case AnalyticType.success:
        return 'success';
      case AnalyticType.send:
        return 'send';
      case AnalyticType.receive:
        return 'receive';
      case AnalyticType.valid:
        return 'valid';
      case AnalyticType.invalid:
        return 'invalid';
      case AnalyticType.search:
        return 'search';
      case AnalyticType.like:
        return 'like';
      case AnalyticType.share:
        return 'share';
      case AnalyticType.comment:
        return 'comment';
      case AnalyticType.input:
        return 'input';
      case AnalyticType.increment:
        return 'increment';
      case AnalyticType.decrement:
        return 'decrement';
      case AnalyticType.accept:
        return 'accept';
      case AnalyticType.decline:
        return 'decline';
      case AnalyticType.alert:
        return 'alert';
    }
  }
}
