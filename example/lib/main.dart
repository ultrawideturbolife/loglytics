import 'package:flutter/material.dart';
import 'package:loglytics/loglytics.dart';

import 'analytics/counter_analytics.dart';
import 'implementations/analytics_implementation.dart';
import 'implementations/crash_reports_implementation.dart';

void main() {
  Loglytics.setUp(
    analyticsInterface: AnalyticsImplementation(Object()),
    crashReportsInterface: CrashReportsImplementation(Object()),
    analytics: (analyticsFactory) {
      analyticsFactory.registerAnalytic(() => CounterAnalytics());
    },
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget with Loglytics {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log.warning('Starting app..');
    return MaterialApp(
      title: 'Loglytics Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Loglytics Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  late final Log log = Log(location: runtimeType.toString());
  late final Loglytics loglytics =
      Loglytics.create(location: runtimeType.toString());

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with Loglytics<CounterAnalytics> {
  int _counter = 0;

  @override
  void initState() {
    widget.log.info('Test the individual logger one two three');
    widget.loglytics.log.info('Test the individual loglytics one two three');
    widget.loglytics.analytics.service.changed(subject: 'nothing');
    widget.loglytics.analytics.service
        .userProperty(property: 'this', value: 'is_so_cool');
    analytics.viewPage();
    super.initState();
  }

  void _incrementCounter() {
    log.info('Pressing increment button..');
    analytics.service.tapped(subject: 'button');
    setState(
      () {
        _counter++;
        log.value(_counter, 'The counter');
        analytics.service.incremented(
          subject: analytics.counterButton,
          parameters: {
            'time': DateTime.now(),
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
          child: Text(widget.title),
          onTap: () {
            log.info('What a weird thing to do..');
            analytics.service.tapped(subject: 'header');
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
