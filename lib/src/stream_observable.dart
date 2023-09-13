import "package:clean_state/clean_state.dart";
import "package:rxdart/rxdart.dart";

/// A class for making stream events easy to share and observe.
///
/// Wrap your [Stream] with [CStreamObservable] to track and broadcast its
/// event changes.
///
/// ### Example:
///
/// ```dart
/// final stream = Stream.periodic( // Create an observable stream.
///   const Duration(seconds: 1),
///   (x) => x,
/// ).take(5).cObserve;
/// final result = stream.value;   // Fetch the stream's latest value from anywhere.
/// ```
///
/// ### See also:
///  * [CController], base class providing lifecycle management for controllers.
///  * [CObservable], for a class that makes values easy to share and observe.
///  * [CObserver], for a widget that updates its child whenever the value of a
///    [CObservable] changes.
///  * [CStreamObserver], for a widget that updates its child whenever the value
///    of a [CStreamObservable] changes.
class CStreamObservable<T> {
  /// A special StreamController that remembers the latest value.
  late BehaviorSubject<T> _subject;

  /// Creates a class for making stream events easy to share and observe.
  ///
  /// The [stream] parameter sets the stream that will update the value.
  /// The optional [value] parameter sets the initial value for observation.
  CStreamObservable(Stream<T> stream, {T? value}) {
    if (value != null) {
      _subject = BehaviorSubject.seeded(value);
    } else {
      _subject = BehaviorSubject();
    }
    _subject.addStream(stream);
  }

  /// Stream of value changes.
  ///
  /// Subscribe to this stream to listen for changes to the observable's value.
  ValueStream<T> get stream => _subject.stream;

  /// Get the most recent value.
  T? get value => _subject.hasValue ? _subject.value : null;
}

/// Extend a [Stream] object with a [CStreamObservable] wrapping.
///
/// Transform any stream into a [CStreamObservable] with a shared value. The
/// stream's latest value can then be fetched at any time.
extension CStreamObservableExtension<T> on Stream<T> {
  /// Convert this stream into an [CStreamObservable].
  ///
  /// Use this extension to change a stream into a [CStreamObservable] with a
  /// shared value. The stream's latest value can then be fetched at any time.
  CStreamObservable<T?> get cObserve => CStreamObservable(this);

  /// Convert this stream into an [CStreamObservable] with an initial value.
  ///
  /// Use this extension to change a stream into a [CStreamObservable] with a
  /// shared value. The stream's latest value can then be fetched at any time.
  CStreamObservable<T?> cObserveSeeded(T value) => CStreamObservable(
        this,
        value: value,
      );
}
