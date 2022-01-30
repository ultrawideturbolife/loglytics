# 📊 Loglytics [![Pub Version](https://img.shields.io/pub/v/loglytics)](https://pub.dev/packages/loglytics)

Loglytics aims to provide a complete solution for simple but powerful logging and simultaneously (but optionally) sending analytics and crash reports inside your apps. Originally this package was created for integration with `firebase_analytics` and `firebase_crashlytics`, but by clever use of a lovely interface it is now also possible to implement other analytics or crash reporting solutions.

In addition to facilitating easier logging and sending of analytics, Loglytics also aims to improve your overall approach to analytics. Everything analytic inside Loglytics is based on *subjects* and *parameters*. Each of your analytics will be wrapped per feature (or other part of our project that you seem fit) and have a list of subjects (e.g. a `'login_button'`) and possible parameters (e.g. `'time_on_page'`) defined for them. In general subjects may have an analytic event attached to them and parameters are for extra detailed information. Because we specify and store our analytics for each feature (or other part of our project) in a central location, we avoid mistakes and create a certain peace, clarity and structure within our projects that is often missed when analytics are sent from all over the place.

# **🔎 How do I start?**

The first thing we need to do is determine if we want to implement custom analytics and/or crash reporting in our project. If we don't, we can still use the `Loglytics` to log and send basic analytics without having to configure anything. If we **do** want to use one or both of them we must implement the `AnalyticsInterface` and `CrashReportsInterface` respectively, so we can pass them along to the `Loglytics.setUp()` method. We will need to call the `Loglytics.setUp()` method before we can send any analytics or crash reports using this package. See below for an example of an implementation of where `FirebaseAnalytics` and `FirebaseCrashlytics` were used. Also notice the callback that is given to the `analytics` parameter. These are needed to facilitate easy access to our implementation of `Analytics` objects. More on `Analytics` objects later.

### **AnalyticsInterface**

```dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:loglytics/analytics/analytics_interface.dart';

class AnalyticsImplementation implements AnalyticsInterface {
  AnalyticsImplementation(this._firebaseAnalytics);
  final FirebaseAnalytics _firebaseAnalytics;

  @override
  Future<void> logEvent({required String name, Map<String, Object?>? parameters}) =>
      _firebaseAnalytics.logEvent(name: name, parameters: parameters);

  @override
  Future<void> resetAnalyticsData() => _firebaseAnalytics.resetAnalyticsData();

  @override
  Future<void> setCurrentScreen({required String name, String? screenClassOverride}) {
    if (screenClassOverride != null) {
      return _firebaseAnalytics.setCurrentScreen(
          screenName: name, screenClassOverride: screenClassOverride);
    } else {
      return _firebaseAnalytics.setCurrentScreen(screenName: name);
    }
  }

  @override
  Future<void> setUserId(String? id) => _firebaseAnalytics.setUserId(id);

  @override
  Future<void> setUserProperty({required String name, required String? value}) =>
      _firebaseAnalytics.setUserProperty(name: name, value: value);
}
```

### **CrashReportsInterface**

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:loglytics/crashlytics/crashlytics_interface.dart';

class CrashReportsImplementation implements CrashReportsInterface {
  CrashReportsImplementation(this._firebaseCrashlytics);
  final FirebaseCrashlytics _firebaseCrashlytics;

  @override
  Future<void> log(String message) => _firebaseCrashlytics.log(message);

  @override
  Future<void> recordError(
    exception,
    StackTrace? stack, {
    reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) =>
      _firebaseCrashlytics.recordError(
        exception,
        stack,
        reason: reason,
        information: information,
        printDetails: printDetails,
        fatal: fatal,
      );

  @override
  Future<void> setCustomKey(String key, Object value) =>
      _firebaseCrashlytics.setCustomKey(key, value);

  @override
  Future<void> setUserIdentifier(String identifier) =>
      _firebaseCrashlytics.setUserIdentifier(identifier);
}
```

### **SetUp**

```dart
Loglytics.setUp(
    analyticsInterface: AnalyticsImplementation(Object()),
    crashReportsInterface: CrashReportsImplementation(Object()),
  );
```

# **📈 How do I send analytics (and crash reports)?**

Next we need to determine how we want to implement the feature-like way of specifying analytics in our project. In any case, it is important that we can define parts of our project (such as a feature) and link them to subjects and parameters for that specific part (or feature). Once we are clear on how we want to do this, we can set up our first implementation of an `Analytics` object. See below for an example of what an implementation for a login feature with one subject and one parameter looks like.

```dart
import 'package:loglytics/loglytics.dart';

class LoginAnalytics extends Analytics {
  final String loginButton = 'login_button';
  final String timeOnPage = 'time_on_page';
  
  final String _loginView = 'login_view';

  void viewPage() => service.viewed(subject: _loginView);
}
```

After having specified the subject and parameter we now have to add the `LoginAnalytics` object to the `Loglytics.setUp` call we mentioned earlier. We do this by registering the object inside the `AnalyticsFactory` via the `registerAnalytic` method. This method takes a callback that's used to provide the `Analytics` using dependency injection and the `get_it` package. Together it should look like a bit like this:

```dart
Loglytics.setUp(
    analyticsImplementation: AnalyticsImplementation(Object()),
    crashReportsImplementation: CrashReportsImplementation(Object()),
    shouldLogAnalytics: true,
    analytics: (analyticsFactory) {
      analyticsFactory.registerAnalytic(() => LoginAnalytics());
    },
);
```

⚠️ *Keep in mind that we use a separate instance of `GetIt` to maintain these callbacks. If your app uses `GetIt` and you reset it every now and then, don’t forget to reset these as well (or choose not to, your choice).*

Now we can move on to our fist usage of a `Loglytics` `mixin`. We use the name of the login `Analytics` implementation we just made as a generic argument for the `Loglytics` `mixin`. This looks like the following:

```dart
class LoginClass with Loglytics<LoginAnalytics> {}
```

**💡** *Tip: Comment your Analytics implementations and create a dart doc for your analyst, this way they have an up to date overview of all the analytics that are being sent from within the app!*

That's it, now we have everything at our disposal to log and send analytics for this feature/part of your app. Now when we type in `analytics` and then choose one of the actions we will have all our defined subjects and parameters (for that feature/part of our app) at our disposal in a callback (🆒). Using it could look like this:

```dart
class LoginClass with Loglytics<LoginAnalytics> {
  
  void initialise() {
    // Other code here
    analytics.viewPage();
  }
  
  void login() {
    // Let's log the tap of the button here.
    analytics.service.tapped(subject: analytics.loginButton);
    // Do your regular code here.
    // Let's assume the login succeeds.
    analytics.service.succeeded(
      subject: analytics.login,
      parameters: {
        // That took a while
        analytics.timeOnPage: 123,
      },
    );
  }
}
```

## **🔧 Custom Analytics**

Should we want to use our own methods inside our `Analytics` implementations (instead of subject `String`s), then we can use the `CustomAnalytic` object. This is a simple wrapper that takes an event name and optional parameters. In order to send it we must call the event method. This method will behave similarly as the other methods except that it has only one callback, and it expects a `CustomAnalytic` object as return value (which you will be able to pass down from your `Analytics` implementation with specific methods). Implementing it could look like this:

```dart
class ExampleAnalytics extends Analytics {
  // Event names
  final buttonViewedWithSomeMagic = 'button_viewed_with_some_magic';
  // Parameters
  final name = 'name';

  CustomAnalytic buttonViewedWithSomeMagic(String buttonName) => CustomAnalytic(
    name: buttonViewedWithSomeMagic,
    parameters: {
      name: buttonName,
    },
  );
}
```

Using it could look like this:

```
void _doSomething() {
  analytics.service.custom(analytic: analytics.buttonViewedWithSomeMagic('magic_button'));
}
```

## ☝️Using the classes independently

Since version 0.10.0 it is also possible to create the `Log`, `Loglytics` and `AnalyticsService` objects on their own. If you defined a `CrashlyticsInterface` or `AnalyticsInterface` in the `Loglytics.setUp` method these will also be sending events to their respective implementations. Defining three classes could look a little something like this:

```dart
class IndividualUsage {
  late final Loglytics loglytics = Loglytics.create(location: runtimeType.toString());
  late final Log log = Log(location: runtimeType.toString());
  late final AnalyticsService analyticsService = AnalyticsService();
}
```

# **🥑 Additional information**

If you have any suggestions for default subjects/parameters and/or ideas for this package please send me an email via info@codaveto.com and I will get to it ASAP.

**Todo:**

- Add logSum functionality (logging of events that won't send until signaled to do so).
- Add annotations for flexible creation of events.
- Add tests.
- Improve example project with comments and more examples.
