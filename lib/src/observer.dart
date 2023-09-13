import "package:flutter/widgets.dart";

import "observable.dart";

/// A widget that updates its child whenever the value of the provided
/// [CObservable] changes.
///
/// ### Example:
///
/// ```dart
/// class MyHomePage extends StatelessWidget {
///   final _counter = 0.cObserve;                  // 1. Turn the value into an observable.
///   void _incrementCounter() => _counter.value++; // 2. Update the value.
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Center(
///         child: CObserver(        // 3. Wrap the widget to update into CObserver.
///           observable: _counter,  // 4. Provide the observable to watch.
///           builder: (context, counter) => Text('$counter'), // 5. The widget will be rebuilt whenever the value changes.
///         ),
///       ),
///       floatingActionButton: FloatingActionButton(
///         onPressed: _incrementCounter,
///        child: const Icon(Icons.add),
///      ),
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
///  * [CStreamObserver], for a widget that updates its child whenever the value
///    of a [CStreamObservable] changes.
class CObserver<T> extends StatelessWidget {
  /// The [CObservable] to keep track of.
  final CObservable<T> observable;

  /// A function for building the child widget based on the [CObservable] value.
  final Widget Function(BuildContext context, T value) builder;

  /// Creates a widget that updates its child when the value of the provided
  /// [CObservable] changes.
  const CObserver({super.key, required this.observable, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: observable.stream,
      initialData: observable.value,
      builder: (context, snapshot) => builder(context, snapshot.requireData),
    );
  }
}
