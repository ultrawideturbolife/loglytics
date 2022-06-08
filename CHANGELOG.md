## 0.11.0+1

* **✨ New:** Added `verified' command.
* Fix example project

## 0.11.0

* **⚠️ Breaking:** Let `AnalyticsService.userProperty` accept nullable values.

## 0.10.5

* **⚠️ Breaking:** Renamed `Loglytics.dispose` to `Loglytics.disposeMe` to avoid a rare bug where classes that already have a dispose method and implementing `Loglytics` would result in a `RangeError` when compiling.

## 0.10.4

* **⚠️ Breaking:** Made `Loglytics.getIt` static to allow for mock generation of classes that implement `Loglytics`.
* **✨ New:** Added `snoozed` command.

## 0.10.3+1

* **✨ New:** Added `taken` command.

## 0.10.3

* **✨ New:** Add `Loglytics.getIt<E extends Analytics>()` method to provide access to other analytics objects rather than always only the one specified as a generic argument of Loglytics.
* **✨ New:** Added `given` command.

## 0.10.2+2

* **✨ New:** Added `[SCREEN]` tag to debug log when logging screen analytics.
* **✨ New:** Added `Log.broadcastLogs` boolean to indicate whether to broadcast logs through newly added `StreamControllers` `Log.analyticsObserver` and `Log.crashReportsObserver`.

## 0.10.2+1

* **✨ New:** Added `analytics.found`, `analytics.notfound`, `analytics.completed` and `analytics.error`.

## 0.10.2

* **✨ New:** Added `LogType.test` and extra convenience methods for `test`, `bloc`, `debug` and `mvvm`.
* **✨ New:** Added `showTime` and `location` to convenience methods.
* **⚠️ Breaking:** Removed `logType` from `Log.info`.

## 0.10.1+6

* **🐛️ Bugfix:** Removed unwanted character at location log.

## 0.10.1+5

* **🐛️ Bugfix:** Made `Loglytics.create` return proper `Analytics` object.

## 0.10.1+4

* Made `EventBus` streams broadcast streams to avoid listen error when resetting.

## 0.10.1+3

* **🐛️ Bugfix:** Add better checks to `EventBus` streams.

## 0.10.1+2

* **🐛️ Bugfix:** Made `EventBus.dispose` return a `Future`.

## 0.10.1+1

* **🐛️ Bugfix:** Made reset analytics methods return a `Future`.

## 0.10.1

* **✨ New:** Added `Loglytics.isActive` bool to facilitate checking if `Loglytics` has already been initialized.
* **🐛️ Bugfix:** Added actual assignment to subscriptions in the `EventBus`.
* **🐛️ Bugfix:** Fixed type in `Loglytics.setUp`.

## 0.10.0

* **✨ New:** Added a `Loglytics.create()` method to allow for easy creation of `Loglytics` objects when using an object is preferred over using a `mixin`.
* **✨ New:** Added a `Log` a logger class that holds all logging capabilities and may be initialised on its own.
* **✨ New:** Implemented an `EventBus` that handles crash reporting events in chronological order instead of `unawaiting` all of them. You choose to handle separate event streams for analytics and logging or to combine them by setting the `combineEvents` boolean in the `Loglytics.setUp` methods to true or false.
* **⚙️ Refactor:** Removed description as a named parameter inside the `log.value` method and replaced it with a positional parameter to allow for smoother logging.
* **⚠️ Breaking:** `Loglytics` will now create its own instance of `GetIt`.
* **⚠️ Breaking:** Removed a lot of required parameters for different classes.
* **⚠️ Breaking:** Moved the logging functionality to its own `Log` class to allow for easier initialisation of pure loggers and clearing up the IntelliSense clutter when a class has implemented `Loglytics`, any previous logging method is now available under the `log` method.
* **⚠️ Breaking:** Removed the convenience methods `logDispose` and `logInitialise`.
* **⚠️ Breaking:** Removed all `customLog` methods.
* **⚠️ Breaking:** Removed the `ConstLoglytics` class.
* **⚠️ Breaking:** Removed the `shouldLogAnalytics` boolean.
* **⚠️ Breaking:** Removed the `CoreSubjects` class.
* Added '[PROPERTY]' tag to debug log when setting user property to create better distinction between analytics logging and user property logging.
* Added the location of the log as '[$location]' to crash reporting.
* Added a several methods so analytics objects may be registered / reset independently of the `Loglytics.setUp`.
* Added a separate `Loglytics.registerAnalytics` method so analytics may be registered separately from the `Loglytics.setUp`.

## 0.9.5+2

* **✨ New:** Added new methods `saved` and `loaded`.
* Ensured that `logError` uses the message as error when no error is given.

## 0.9.5+1

* **✨ New:** Added new methods `unsupported`, `invalid`, `valid` and `shown`.

## 0.9.5

* **✨ New:** Added `LogType.value` with proper icon and name
* **✨ New:** Added custom `location` and removal of `time` to default `log` method.

## 0.9.4+2

- Fix small bug where new log type would not get parsed.

## 0.9.4+1

* **✨ New:** Add `LogType.debug`, `LogType.bloc` and `LogType.mvvm` as log types.

## 0.9.4

* **✨ New:** Added `customLogError` method for logging errors when use of a mixin is not possible.

## 0.9.3+1

- Update stack trace of logError to ignore logError line.

## 0.9.3

* **✨ New:** Added `forceRecordError` to logError method.
* **✨ New:** Added `generated` method to `AnalyticsService`.

## 0.9.2+1

- Update stack trace debug print and config.

## 0.9.2

- Update stack trace debug print and config.

## 0.9.1+8

- Fix another crash reporting bug

## 0.9.1+7

- Fix crash reporting bug

## 0.9.1+6

- Improve logging

## 0.9.1+5

- Improve logging

## 0.9.1+4

- Expose implementations in both const and regular loglytics.

## 0.9.1+3

- Expose implementations.

## 0.9.1+2

- Update debug print statement of analytics parameters.

## 0.9.1+1

- Update debug print statement of analytics parameters.

## 0.9.1

* **✨ New:** Added const version of `Loglytics` => `ConstLoglytics`.

## 0.9.0+2

* **🐛️ Bugfix:** Made `Loglytics.analytics` final.

## 0.9.0+1

* Fix readme.

## 0.9.0

* **✨ New:** Added the `AnalyticsService` to each `Analytics` object, grab it with the `service` getter.
* **⚠️ Breaking:** Removed the `_CoreData` from the `Analytics` object. It is still available so just add it manually when you see fit in your own implementations.
* **⚠️ Breaking:** Removed the `AnalyticsService` from the `Loglytics` object. The `analytics` getter will now pass you your `Analytics` implementation directly (which holds the `AnalyticsService`).
* **⚠️ Breaking:** Refactored all callbacks in the `AnalyticsService` to accept regular `String`s and `Map`s.
* **⚠️ Breaking:** Renamed the `AnalyticsService.event` method to `AnalyticsService.custom`.

## 0.8.1+1

* Fix readme.

## 0.8.1

* **✨ New:** Add `toCustomAnalytic` extension method to all `AnalyticsTypes` enums to allow for more flexible custom analytics creations.

## 0.8.0+1

* Fix example project and formatting.

## 0.8.0

* **✨ New:** Added a `CustomAnalytic` object to allow for custom methods in your `Analytics` implementations.
* **⚠️ Breaking:** Refactored the `AnalyticsService.event` method.

## 0.7.4

* **✨ New:** Added new `Loglytics.logKeyValue` method.
* Refactored `message` to `description` and added `description` to some log methods.

## 0.7.3+1

* **🐛️ Bugfix:** Fix `Loglytics.value` print again.

## 0.7.3

* **🐛️ Bugfix:** Fix `Loglytics.value` print.

## 0.7.2

* **🐛️ Bugfix:** Remove `AnalyticsService.input` method unwanted change.

## 0.7.1

* **🐛️ Bugfix:** Remove `logError` method unwanted change.

## 0.7.0

* **⚠️ Breaking:** Most events are now past tense and have refactored methods.
* **✨ New:** Added new events.
* **✨ New:** Added new `addToCrashReports` boolean to each log to facilitate hiding sensitive info from crash reports.
* **✨ New:** Added new `errorStackTraceStart` and `errorStackTraceEnd` ints to allow for StackTrace printing length configuration.
* **✨ New:** Changed `AnalyticsService.reset` to `AnalyticsService.resetAnalytics`.

## 0.6.0

* **🐛️ Bugfix:** Set up method only allow one Analytics object to be passed due to wrong use of generics.
* **⚠️ Breaking:** Setup method was refactored to pass an `AnalyticsFactory` to register all your analytics with.

## 0.5.0

* **⚠️ Breaking:** Loglytics was completely refactored.
  * `LoglyticsWrapper` was removed and doesn't have to be overridden anymore;
  * `LoglyticsSubjects` was removed and doesn't have to be implemented anymore;
  * `LoglyticsParameters` was removed and doesn't have to be implemented anymore;
  * `Analytics` object was introduced and is now the only class you have to implement and add to `Loglytics` `mixin` (as a generic) for access to your custom analytics.
  * Added a bunch of handy default analytics that are accessible through `analytics.core` (even without specifying a generic 🆒).

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
