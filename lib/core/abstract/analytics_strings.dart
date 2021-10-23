abstract class AnalyticsStrings<S extends AnalyticsSubjects, P extends AnalyticsParameters> {
  S get subjects;
  P get parameters;
}

abstract class AnalyticsSubjects {}

abstract class AnalyticsParameters {}
