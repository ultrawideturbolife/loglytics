# 📊 Loglytics [![Pub Version](https://img.shields.io/pub/v/loglytics)](https://pub.dev/packages/loglytics)

Loglytics aims to provide a complete solution for simple but powerful logging and simultaneously (but optionally) sending analytics and crash reports inside your apps. Originally this package was created for integration with `firebase_analytics` and `firebase_crashlytics`, but through an interface it is now also possible to implement your own analytics or crash reporting solutions.

Besides trying to facilitate easier logging and sending of analytics, Loglytics also aims to improve your overall approach to analytics. Everything analytic inside Loglytics is based on *subjects* and *parameters*. Each of your analytics will be grouped per feature (or other part of our project that you seem fit) and they will have a list of subjects (e.g. a `'login_button'`) and possible parameters (e.g. `'time_on_page'`) defined for them. In general subjects may have an analytic event attached to them and parameters are for extra information. Because we specify and save our analytics in a central location for each feature (or other part of our project), we create a certain peace, clarity and structure within our projects that's often missed when analytics are being sent from all over the place.

# 🔎 How do I start?

The first thing we need to do is determine if we want to implement analytics and/or crash reporting in your project. If we don't, we can still use the `Loglytics` to log anything and everywhere without having to configure anything. If we do want to use one or both of them we must implement the `AnalyticsInterface` and `CrashReportsInterface` respectively so we can pass them along to the `Loglytics.setup()` method. We will need to call the `Loglytics.setup()` method before we can send any analytics or crash reports using this package. See below for an example of an implementation of where `FirebaseAnalytics` and `FirebaseCrashlytics` were used.

### AnalyticsInterface

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

### CrashReportsInterface

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

### Setup

```dart
void main() {
  Loglytics.setup(
    analyticsImplementation: AnalyticsImplementation(
      FirebaseAnalytics(),
    ),
    crashReportsImplementation: CrashReportsImplementation(
      FirebaseCrashlytics.instance,
    ),
    shouldLogAnalytics: true,
  );
  runApp(MyApp());
}
```

# 📈 How do I send analytics (and crash reports)?

Next we need to determine how we want to implement the feature-like way of specifying analytics in our project. In any case, it is important that we can define parts of our project (such as a feature) and link them to subjects and parameters for that specific part (or feature). Once we are clear on how we want to do this, we can set up our first implementation of a `FeatureAnalytics`. See below for an example of what a template of that looks like.

```dart
import 'package:loglytics/loglytics.dart';

class TemplateAnalytics extends FeatureAnalytics<TemplateSubjects, TemplateParameters> {
  @override
  TemplateSubjects get subjects => _templateSubjects;
  late final TemplateSubjects _templateSubjects = TemplateSubjects();

  @override
  TemplateParameters get parameters => _templateParameters;
  late final TemplateParameters _templateParameters = TemplateParameters();
}

class TemplateSubjects extends FeatureSubjects {}

class TemplateParameters extends FeatureParameters {}
```

Defining our first `FeatureAnalytics` consists of 3 steps:

1. **Rename the TemplateAnalytics, TemplateSubjects and TemplateParameters.**
    
    We can do this in a smart way by finding the word `Template` throughout the file and replacing it with the name of the feature or part of our project that these analytics are for. We will use `Login` as our feature in this example.
    
2. **Specifying your first subjects.**
    
    We can do this by defining our first subjects as immutable variables in our just renamed `TemplateSubjects`. Subjects are, as the name implies, subjects of a certain feature/part of our app. These can be obvious things like buttons (for example `'login_button'`) and screens (for example `'login_screen'`), but also actions itself like login (`'login'`). Based on these subjects we will later send analytic events to our provider. For example a `'login_button'` might get a `tap`, a `'login_screen'` might get a `view` and a `'login'` might get `success`.
    
3. **Specifying your first parameters.**
    
    We can do this by defining our first parameters as immutable variables in our just renamed `TemplateParameters`. Parameters are not always applicable, but they can often communicate additional valuable information. For example, when logging in, think about the number of failed attempts (`'number_of_tries'`) or the amount of time the user took (`'time_on_page’`) to login. Check out the example below for more information.
    

```dart
import 'package:loglytics/loglytics.dart';

class LoginAnalytics extends FeatureAnalytics<LoginSubjects, LoginParameters> {
  @override
  LoginSubjects get subjects => _loginSubjects;
  late final LoginSubjects _loginSubjects = LoginSubjects();

  @override
  LoginParameters get parameters => _loginParameters;
  late final LoginParameters _loginParameters = LoginParameters();
}

class LoginSubjects extends FeatureSubjects {
  final String login = 'login';
  final String loginButton = 'login_button';
}

class LoginParameters extends FeatureParameters {
  final String timeOnPage = 'time_on_page';
}
```

After having specified at least one subject and one parameter we can now move on to our fist usage of a `Loglytics`. As mentioned earlier, the `Loglytics` can be used without analytics. We do this by simply adding the `Loglytics` as a `mixin` to a class. Et voilá now we have all the log capabilities this package has to offer, but without the analytics and crash reporting implementation. However, we do want to use analytics in this example so we specify two generic types when adding the `Loglytics` `mixin`. The two generic types are the implementations of the `FeatureSubjects` and `FeatureParameters` we just made. This looks like the following:

```dart
class LoginClass with Loglytics<LoginSubjects, LoginParameters> {}
```

As a last step we need to override the `Loglytics.featureAnalytics` getter and provide it with our implementation of the `FeatureAnalytics`. That's it, now we have everything at our disposal to log and send analytics for this feature/part of your app. Now when we type in `analytics` and then choose one of the actions we will have all our defined subjects and parameters (for that feature/part of our app) at our disposal in a callback (🆒). This looks like this:

```dart
class LoginClass with Loglytics<LoginSubjects, LoginParameters> {
  void login() {
		// Let's log the tap of the button here.
    analytics.tap(subject: (subjects) => subjects.loginButton);
    // Do your regular code here.
    // Let's assume the login succeeds.
    analytics.success(
      subject: (subjects) => subjects.login,
      parameters: (parameters) => {
				// That took a while
        parameters.timeOnPage: 123,
      },
    );
  }

  @override
  FeatureAnalytics<LoginSubjects, LoginParameters> get featureAnalytics => LoginAnalytics();
}
```

# 🥑 Additional information

**Todo:**

- Add annotations for easier defining of subjects and parameters.
- Improve example project with comments and more examples.
