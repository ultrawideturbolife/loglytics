import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:loglytics/loglytics.dart';

import 'analytics/counter_analytics.dart';
import 'implementations/analytics_implementation.dart';
import 'implementations/crashlytics_implementation.dart';

void main() {
  LogService.setup(
    analyticsImplementation: AnalyticsImplementation(
      FirebaseAnalytics(),
    ),
    crashlyticsImplementation: CrashlyticsImplementation(
      FirebaseCrashlytics.instance,
    ),
    shouldLogAnalytics: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget with LogService {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loglytics Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Loglytics Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with LogService<CounterSubjects, CounterParameters> {
  int _counter = 0;

  @override
  FeatureAnalytics<CounterSubjects, CounterParameters> get featureAnalytics =>
      CounterAnalytics();

  void _incrementCounter() {
    analytics.tap(subject: (subjects) => subjects.counterButton);
    setState(
      () {
        _counter++;
        analytics.success(
          subject: (subjects) => subjects.incrementCounter,
          parameters: (parameters) => {
            parameters.amount: _counter,
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
