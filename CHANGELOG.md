## 0.1.3

* **✨ New:** Added default analytics that are accessible trough `Loglytics.defaultAnalytics` and require no further configuration of the `Loglytics` mixin.
* **⚠️ Breaking:** Renamed the following:
  * `FeatureAnalytics` to `AnalyticsWrapper`;
  * `FeatureSubjects` to `AnalyticsSubjects`;
  * `FeatureParameters` to `AnalyticsParameters`;
  * `Loglytics.featureAnalytics` getter to `Loglytics.wrapper`.
* **✨ New:** Added extra event types and methods.
* **⚠️ Breaking:** Removed create, update, delete event types and methods (these are better fit as subjects).

## 0.1.2

* **⚠️ Breaking:** Rename LogService to Loglytics.
* **⚠️ Breaking:** Rename CrashlyticsInterface to CrashReportingInterface.

## 0.1.1

* Update readme.
* Add formatting to get 130 pub points.

## 0.1.0

* Initial release.
