part of 'loglytics.dart';

/// Used to make sure that events that are fired will be sent in chronological order.
class EventBus {
  EventBus._();
  static final EventBus _eventBus = EventBus._();
  factory EventBus() => _eventBus;

  late final StreamController<Future<void>> _crashReports =
      StreamController.broadcast();
  StreamSubscription? _crashReportsSubscription;
  late final StreamController<Future<void>> _analytics =
      StreamController.broadcast();
  StreamSubscription? _analyticsSubscription;
  late final StreamController<Future<void>> _combinedEvents =
      StreamController.broadcast();
  StreamSubscription? _combinedEventsSubscription;

  /// Adds a crash report to the event stream.
  void tryAddCrashReport(Future<void>? crashReport) {
    if (crashReport != null) {
      if (Loglytics._combineEvents) {
        _combinedEvents.add(crashReport);
      } else {
        _crashReports.add(crashReport);
      }
    }
  }

  /// Adds an analytic report to the event stream.
  void tryAddAnalytic(Future<void>? analytic) {
    if (analytic != null) {
      if (Loglytics._combineEvents) {
        _combinedEvents.add(analytic);
      } else {
        _analytics.add(analytic);
      }
    }
  }

  /// Used ot dispose all event streams.
  Future<void> dispose() async {
    await _crashReportsSubscription?.cancel();
    _crashReportsSubscription = null;
    await _analyticsSubscription?.cancel();
    _analyticsSubscription = null;
    await _combinedEventsSubscription?.cancel();
    _combinedEventsSubscription = null;
  }

  /// Used to start listening to the event streams.
  void _listen() async {
    if (Loglytics._combineEvents) {
      if (!_combinedEvents.hasListener && _combinedEventsSubscription == null) {
        _combinedEventsSubscription = _combinedEvents.stream.listen(
          (future) async => await future,
          onError: (error, stackTrace) async {
            const message =
                '[EventBus] Combined events stream caught an error!';
            debugPrint(message);
            await Loglytics._crashReportsInterface?.log(message);
            await Loglytics._crashReportsInterface
                ?.recordError(error, stackTrace, fatal: true);
          },
          onDone: () async {
            const message = '[EventBus] Combined events stream is done!';
            debugPrint(message);
            await Loglytics._crashReportsInterface?.log(message);
          },
        );
      }
    } else {
      if (!_crashReports.hasListener && _crashReportsSubscription == null) {
        _crashReportsSubscription ??= _crashReports.stream.listen(
          (future) async => await future,
          onError: (error, stackTrace) async {
            const message =
                '[EventBus] CrashReports events stream caught an error!';
            debugPrint(message);
            await Loglytics._crashReportsInterface?.log(message);
            await Loglytics._crashReportsInterface
                ?.recordError(error, stackTrace, fatal: true);
          },
          onDone: () async {
            const message = '[EventBus] CrashReports events stream is done!';
            debugPrint(message);
            await Loglytics._crashReportsInterface?.log(message);
          },
        );
      }
      if (!_analytics.hasListener && _analyticsSubscription == null) {
        _analyticsSubscription ??= _analytics.stream.listen(
          (future) async => await future,
          onError: (error, stackTrace) async {
            const message =
                '[EventBus] Analytics events stream caught an error!';
            debugPrint(message);
            await Loglytics._crashReportsInterface?.log(message);
            await Loglytics._crashReportsInterface
                ?.recordError(error, stackTrace, fatal: true);
          },
          onDone: () async {
            const message = '[EventBus] Analytics events stream is done!';
            debugPrint(message);
            await Loglytics._crashReportsInterface?.log(message);
          },
        );
      }
    }
  }
}
