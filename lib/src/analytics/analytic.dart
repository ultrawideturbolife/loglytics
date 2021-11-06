import '../enums/analytics_types.dart';

/// Core class that's used to structure and provide analytics in the [AnalyticsService].
///
/// This is mostly used under the hood.
class Analytic {
  const Analytic({
    required String subject,
    required AnalyticsTypes type,
    this.parameters,
  })  : _subject = subject,
        _type = type;

  final String _subject;
  final AnalyticsTypes _type;
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
