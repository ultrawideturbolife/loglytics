## 0.5.0

* **⚠️ Breaking:** Loglytics was completely refactored.
  * `LoglyticsWrapper` was removed and doesn't have to be overridden anymore;
  * `LoglyticsSubjects` was removed and doesn't have to be implemented anymore;
  * `LoglyticsParameters` was removed and doesn't have to be implemented anymore;
  * `Analytics` object was introduced and is now the only you have to add to `Loglytics` `mixin` for access to your custom analytics.
  * Added a bunch of handy default analytics that are accessible through `analytics.core`.

## 0.4.0+1

* Fix changelog.

## 0.4.0

* **⛔️ NOTE:** Loglytics was unaware of the rules for semantic versioning. Please be aware that versions 0.1.2, 0.1.3 and 0.1.4 are not compatible with each other. Also, please be aware that from this day forth Loglytics will keep the semantic versioning rules in mind when specifying new versions 🙃.

## 0.1.4

* **⚠️ Breaking:** Renamed the following:
  * `core_analytics.dart` to `default_analytics.dart`;
  * `analytics_wrapper.dart` to `loglytics_wrapper.dart`.
* **🐛️ Bugfix:** Remove **required** *crashReportsInterface* when calling `customLog`.

## 0.1.3

* **✨ New:** Added default analytics that are accessible trough `Loglytics.defaultAnalytics` and require no further configuration of the `Loglytics` mixin.
* **⚠️ Breaking:** Renamed the following:
  * `FeatureAnalytics` to `LoglyticsWrapper`;
  * `FeatureSubjects` to `LoglyticsSubjects`;
  * `FeatureParameters` to `LoglyticsParameters`;
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
