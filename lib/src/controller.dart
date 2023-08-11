import "package:flutter/foundation.dart";
import "package:get_it/get_it.dart";

import "observable.dart";

/// A base class providing lifecycle management for controllers.
///
/// It supports the `onInit` and `onDispose` methods, along with the ability to
/// notify listeners.
///
/// ### Example:
///
/// ``` dart
/// // 1. Create a new controller class.
/// class MyHomePageController extends CController {
///   // 2. Place the counter value we'll observe inside.
///   final counter = 0.cObserve;
///
///   // 3. Updates the counter value.
///   void incrementCounter() => counter.value++;
///
///   // Not actually necessary here. But you get the idea.
///   @override
///   void onInit() {
///     super.onInit();
///     print('Controller initiated');
///   }
///
///   @override
///   void onDispose() {
///     print('Controller disposed');
///     super.onDispose();
///   }
/// }
///
/// class MyHomePage extends StatelessWidget {
///   MyHomePage({super.key});
///
///   // 4. Initialize the controller.
///   final controller = MyHomePageController();
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Center(
///         child: CObserver(
///           // 5. Update the text whenever the counter value changes.
///           observable: controller.counter,
///           builder: (context, counter) => Text('$counter'),
///         ),
///       ),
///       floatingActionButton: FloatingActionButton(
///         onPressed: controller.incrementCounter,
///         child: const Icon(Icons.add),
///       ),
///     );
///   }
/// }
/// ```
///
/// ### See also:
///  * [CFutureController], for a controller that manages asynchronous tasks.
///  * [CObservable], for a class that makes values easy to share and observe.
///  * [CObserver], for a widget that updates its child whenever the value of a
///    [CObservable] changes.
///  * [CProvider], for a central hub for managing global instances with easy
///    access.
///  * [CResult], for a representation of an operation's outcome.
abstract class CController implements Disposable {
  /// Creates a base class providing lifecycle management for controllers.
  ///
  /// The `onInit` method is automatically called during construction, allowing
  /// subclasses to perform necessary initialization.
  CController() {
    onInit();
  }

  /// The [CObservable] used for notifying listeners.
  ///
  /// The `notifier` is an observable object used to inform listeners of changes
  /// or updates in the controller's state. Any listener subscribing to this
  /// `notifier` will be notified when the `notify` method is invoked.
  final notifier = Object().cObserve;

  /// Notifies listeners about changes in the controller's state.
  ///
  /// Use this method to notify any listeners subscribed to the `notifier` about
  /// changes in the controller's state.
  void notify() => notifier.notify();

  /// A method called during the controller's initialization phase.
  ///
  /// Subclasses can override this method to perform any necessary
  /// initialization logic when the controller is created.
  @protected
  @mustCallSuper
  void onInit() {}

  /// A method called during the controller's disposal phase.
  ///
  /// Subclasses can override this method to perform any necessary cleanup or
  /// disposal logic when the controller is disposed or no longer needed.
  @protected
  @mustCallSuper
  @override
  void onDispose() {}
}
