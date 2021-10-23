import 'package:loglytics/core/abstract/log_service.dart';

class ExampleClassWithoutAnalytics with LogService {
  void example() {
    try {
      log('Just logging something..');
      logSuccess('That went well.');
    } catch (error, stack) {
      logError(
        'Or maybe not.',
        error: error,
        stack: stack,
        fatal: true,
      );
    }
  }
}
