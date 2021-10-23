abstract class FeatureAnalytics<S extends FeatureSubjects, P extends FeatureParameters> {
  S get subjects;
  P get parameters;
}

abstract class FeatureSubjects {}

abstract class FeatureParameters {}
