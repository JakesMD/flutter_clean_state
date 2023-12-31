import "package:rxdart/rxdart.dart";

/// A class for making values easy to share and observe.
///
/// Wrap your value with [CObservable] to track and broadcast its changes.
///
/// ### Example:
///
/// ```dart
/// final counter = 5.cObserve;                 // Create an observable counter.
/// final subscription = counter.stream.listen( // Subscribe to value changes.
///   (value) => print(value),
/// );
/// counter.value = 10;                         // Update the counter's value from anywhere.
/// final result = counter.value;               // Fetch the counter's value from anywhere.
/// ```
///
/// ### See also:
///  * [CController], base class providing lifecycle management for controllers.
///  * [CObserver], for a widget that updates its child whenever the value of a
///    [CObservable] changes.
///  * [CStreamObservable], for a class that makes stream events easy to share
///    and observe.
///  * [CStreamObserver], for a widget that updates its child whenever the value
///    of a [CStreamObservable] changes.
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
