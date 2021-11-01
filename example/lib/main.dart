import 'package:flutter/material.dart';
import 'package:loglytics/loglytics.dart';

import 'analytics/counter_analytics.dart';
import 'implementations/analytics_implementation.dart';
import 'implementations/crash_reports_implementation.dart';

void main() {
  customLog(message: 'Setting up Loglytics', location: 'main()', logType: LogType.info);
  Loglytics.setup(
    analyticsImplementation: AnalyticsImplementation(Object()),
    crashReportsImplementation: CrashReportsImplementation(Object()),
    shouldLogAnalytics: true,
    analytics: [
      () => CounterAnalytics(),
    ],
  );
  customLog(message: 'Setting up Loglytics', location: 'main()', logType: LogType.info);
  runApp(MyApp());
}

class MyApp extends StatelessWidget with Loglytics {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logWarning('Starting app..');
    logError('also logging from build method.. not a good idea!', printStack: false);
    analytics.start(subject: (analytics) => analytics.core.app);
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

class _MyHomePageState extends State<MyHomePage> with Loglytics<CounterAnalytics> {
  int _counter = 0;

  void _incrementCounter() {
    log('Pressing increment button..');
    analytics.tap(subject: (analytics) => analytics.core.button);
    setState(
      () {
        _counter++;
        logValue(_counter);
        analytics.increment(
          subject: (analytics) => analytics.core.button,
          parameters: (analytics) => {
            analytics.core.time: DateTime.now(),
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            widget.title,
          ),
          onTap: () {
            log('What a weird thing to do..');
            analytics.tap(subject: (analytics) => analytics.core.header);
          },
        ),
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
