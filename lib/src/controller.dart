import "package:flutter/foundation.dart";
import "package:get_it/get_it.dart";

import "observable.dart";

/// A base class providing lifecycle management for controllers.
///
/// It supports the `onInit` and `onDispose` methods, along with the ability to
/// notify listeners.
///
/// Note: onDispose is only called if the controller was registered with the
/// [CProvider].
///
/// ### Example:
///
/// ```dart
/// class MyHomePageController extends CController {
///   var counter = 0;
///
///   void incrementCounter() {
///     counter++;
///     notify();
///   }
///
///   @override
///   void onInit() {
///     super.onInit();
///     print('Controller initialized.');
///   }
/// }
/// ```
///
/// ### See also:
///  * [CObserver], for a widget that updates its child whenever the value of a
///    [CObservable] changes.
///  * [CProvider], for a central hub for managing global instances with easy
///    access.
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
  ///
  /// Note: This is only called if the controller was registered with the
  /// [CProvider].
  @protected
  @mustCallSuper
  @override
  void onDispose() {}
}
