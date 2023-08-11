import "package:rxdart/rxdart.dart";

/// A class for making values easy to share and observe.
///
/// Wrap your value with [CObservable] to track and broadcast its changes.
///
/// ### Example:
///
/// ``` dart
/// // Create an observable counter.
/// final counter = 5.cObserve;
///
/// // Subscribe to value changes.
/// final subscription = counter.stream.listen((value) => print(value));
///
/// // Update the counter's value.
/// counter.value = 10;
/// ```
///
/// ### See also:
///  * [CObservableExtension], for converting any object into a streamable value.
///  * [CController], base class providing lifecycle management for controllers.
///  * [CFutureController], for a controller that manages asynchronous tasks.
///  * [CObserver], for a widget that updates its child whenever the value of a
///    [CObservable] changes.
///  * [CProvider], for a central hub for managing global instances with easy
///    access.
///  * [CResult], for a representation of an operation's outcome.
class CObservable<T> {
  /// A special StreamController that remembers the latest value.
  final BehaviorSubject<T> _subject;

  /// Creates a class for making values easy to share and observe.
  ///
  /// The [value] parameter sets the initial value for observation.
  CObservable(T value) : _subject = BehaviorSubject.seeded(value);

  /// Stream of value changes.
  ///
  /// Subscribe to this stream to listen for changes to the observable's value.
  ValueStream<T> get stream => _subject.stream;

  /// Get the most recent value.
  T get value => _subject.value;

  /// Update the value and inform listeners.
  ///
  /// Use this to change the observable's value. All registered listeners will
  /// be notified with the new value.
  set value(T newValue) => _subject.add(newValue);

  /// Another way to update the value and inform listeners.
  ///
  /// This method is the same as `value = newValue`, offering flexibility.
  set(T newValue) => _subject.add(newValue);

  /// Notify listeners even if the value hasn't changed.
  ///
  /// Manually tell all registered listeners about the current value, even if
  /// it hasn't changed. Useful when you want to trigger updates without
  /// modifying the value.
  void notify() => _subject.add(_subject.value);
}

/// Extend any object with a [CObservable] wrapping.
///
/// Transform any object into a [CObservable] with a streamable value using
/// this extension. The object becomes observable and can be monitored for
/// value changes.
extension CObservableExtension<T> on T {
  /// Convert this object into a streamable value.
  ///
  /// Use this extension to change any object into a [CObservable] with a
  /// streamable value. The object can then be observed and listened to for
  /// changes in its value.
  CObservable<T> get cObserve => CObservable<T>(this);
}
