part of 'loglytics.dart';

/// Used to make sure that events that are fired will be sent in chronological order.
class EventBus {
  EventBus._();
  static late final EventBus _eventBus = EventBus._();
  factory EventBus() => _eventBus;

  late final StreamController<Future<void>> _crashReports = StreamController();
  StreamSubscription? _crashReportsSubscription;
  late final StreamController<Future<void>> _analytics = StreamController();
  StreamSubscription? _analyticsSubscription;
  late final StreamController<Future<void>> _combinedEvents =
      StreamController();
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
  void dispose() {
    _crashReportsSubscription?.cancel();
    _crashReportsSubscription = null;
    _analyticsSubscription?.cancel();
    _analyticsSubscription = null;
    _combinedEventsSubscription?.cancel();
    _combinedEventsSubscription = null;
  }

  /// Used to start listening to the event streams.
  void _listen() async {
    if (Loglytics._combineEvents) {
      _combinedEventsSubscription ??= _combinedEvents.stream.listen(
        (future) async => await future,
        onError: (error, stackTrace) async {
          const message = '[EventBus] Combined events stream caught an error!';
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
    } else {
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
      _analyticsSubscription ??= _analytics.stream.listen(
        (future) async => await future,
        onError: (error, stackTrace) async {
          const message = '[EventBus] Analytics events stream caught an error!';
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
