import "package:clean_state/src/stream_observable.dart";
import "package:flutter/widgets.dart";

import "observable.dart";

/// A widget that updates its child whenever the value of the provided
/// [CStreamObservable] changes.
///
/// ### Example:
///
/// ``` dart
/// class Example extends StatelessWidget {
///   final _stream = Stream.periodic(
///     const Duration(seconds: 1),
///     (x) => x,
///   ).take(5).cObserve;
///
///  @override
///  Widget build(BuildContext context) {
///    return CStreamObserver(
///      observable: _stream,
///      builder: (context, snapshot) {
///        if (snapshot.hasData) return Text('${snapshot.data}');
///        return const Text('Nothing here.');
///      },
///    );
///  }
/// }
/// ```
///
/// ### See also:
///  * [CController], base class providing lifecycle management for controllers.
///  * [CObservable], for a class that makes values easy to share and observe.
///  * [CStreamObservable], for a class that makes stream events easy to share
///    and observe.
class CStreamObserver<T> extends StatelessWidget {
  /// The [CStreamObservable] to keep track of.
  final CStreamObservable<T> observable;

  /// A function for building the child widget based on the [CStreamObservable]
  /// value.
  final Widget Function(BuildContext context, AsyncSnapshot<T> value) builder;

  /// Creates a widget that updates its child when the value of the provided
  /// [CStreamObservable] changes.
  const CStreamObserver({
    super.key,
    required this.observable,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: observable.stream,
      initialData: observable.value,
      builder: builder,
    );
  }
}
