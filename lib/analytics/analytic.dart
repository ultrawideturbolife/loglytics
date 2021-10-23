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

  String get name => '$_subject\_${_type.name}';

  bool equals(Analytic? other) =>
      other != null &&
      (identical(this, other) ||
          runtimeType == other.runtimeType &&
              _subject == other._subject &&
              _type == other._type &&
              parameters == other.parameters);
}

enum AnalyticType {
  tap,
  focus,
  unFocus,
  select,
  view,
  open,
  close,
  create,
  update,
  delete,
  fail,
  success,
  valid,
  invalid,
  search,
  share,
  input,
  screen,
  event
}

extension on AnalyticType {
  String get name {
    switch (this) {
      case AnalyticType.tap:
        return 'tap';
      case AnalyticType.focus:
        return 'focus';
      case AnalyticType.unFocus:
        return 'unfocus';
      case AnalyticType.select:
        return 'select';
      case AnalyticType.view:
        return 'view';
      case AnalyticType.open:
        return 'open';
      case AnalyticType.close:
        return 'close';
      case AnalyticType.create:
        return 'create';
      case AnalyticType.update:
        return 'update';
      case AnalyticType.delete:
        return 'delete';
      case AnalyticType.fail:
        return 'fail';
      case AnalyticType.success:
        return 'success';
      case AnalyticType.valid:
        return 'valid';
      case AnalyticType.invalid:
        return 'invalid';
      case AnalyticType.search:
        return 'search';
      case AnalyticType.share:
        return 'share';
      case AnalyticType.input:
        return 'input';
      case AnalyticType.screen:
        return 'screen';
      case AnalyticType.event:
        return 'event';
    }
  }
}
