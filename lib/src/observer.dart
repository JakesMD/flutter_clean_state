import "package:flutter/widgets.dart";

import "observable.dart";

/// A widget that updates its child whenever the value of the provided
/// [CObservable] changes.
///
/// ### Example:
///
/// ``` dart
/// class MyHomePage extends StatelessWidget {
///   MyHomePage({super.key});
///
///   // 1. The star of the show – the value we're observing.
///   final _counter = 0.cObserve;
///
///   // 2. Updates the value.
///   void _incrementCounter() => _counter.value++;
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Center(
///         child: CObserver(
///           // 3. Pop your widget into CObserver and let it know what to watch.
///           observable: _counter,
///
///           // 4. Your widget will be rebuilt whenever the value changes.
///           builder: (context, counter) => Text('$counter'),
///         ),
///       ),
///       floatingActionButton: FloatingActionButton(
///         onPressed: _incrementCounter,
///         child: const Icon(Icons.add),
///       ),
///     );
///   }
/// }
/// ```
///
/// ### See also:
///  * [CController], base class providing lifecycle management for controllers.
///  * [CFutureController], for a controller that manages asynchronous tasks.
///  * [CObservable], for a class that makes values easy to share and observe.
///  * [CProvider], for a central hub for managing global instances with easy
///    access.
///  * [CResult], for a representation of an operation's outcome.
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
