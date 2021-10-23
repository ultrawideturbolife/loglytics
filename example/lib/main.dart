import 'package:example/example_analytics.dart';
import 'package:example/example_class_with_analytics.dart';
import 'package:flutter/material.dart';
import 'package:loglytics/core/abstract/log_service.dart';

void main() {
  LogService.setup(
    analyticsEnabled: false,
    crashlyticsEnabled: false,
    logAnalyticsEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
    with LogService<ExampleAnalyticsSubjects, ExampleAnalyticsParameters> {
  int _counter = 0;

  final ExampleClassWithAnalytics exampleClassWithAnalytics = ExampleClassWithAnalytics();

  void _incrementCounter() {
    exampleClassWithAnalytics.example();
    analytics.tap(subject: (subjects) => subjects.exampleButton);
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
