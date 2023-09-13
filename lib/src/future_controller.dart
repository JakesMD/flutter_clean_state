import 'dart:async';
import 'dart:developer';

import 'package:clean_state/clean_state.dart';

/// Represents the different states of an asynchronous operation.
enum CFutureState {
  /// The operation is currently in progress.
  inProgress,

  /// The operation encountered an error.
  fail,

  /// The operation completed successfully.
  success,
}

/// A controller for managing asynchronous tasks and their corresponding states.
///
/// [CFutureController] simplifies the handling of asynchronous tasks by
/// managing their progress and completion states, resulting in cleaner and more
/// organized code.
///
/// ### Example:
///
/// ```dart
/// Future<CResult<String, Exception>> fetchData() async { // 1. Make your asynchronous tasks return a CResult.
///   await Future.delayed(const Duration(seconds: 3));
///   return const CSuccess('Hello World');
/// }
///
/// class MyWidget extends StatelessWidget {
///   final controller = CFutureController(                 // 2. Initialize a controller.
///     onStateChange: (state) => print(state),
///   );
///   void load() async => await controller.run(fetchData); // 3. Run a task in the controller.
///
///   @override
///   Widget build(BuildContext context) {
///     return GestureDetector(
///       onTap: load,
///       child: CObserver( // 4. Observe the controller for state changes.
///         observable: controller.notifier,
///         builder: (context, _) {
///           switch (controller.state) {  // 5. Update your UI according to the current state.
///             case CFutureState.fail:
///               return const Text('Error');
///             case CFutureState.inProgress:
///               return const Text('Loading');
///             case CFutureState.success:
///               return const Text('Success');
///           }
///         },
///       ),
///     );
///   }
/// }
/// ```
///
/// ### See also:
///  * [CFutureState], for the different states of an asynchronous operation.
///  * [CController], base class providing lifecycle management for controllers.
///  * [CObservable], for a class that makes values easy to share and observe.
///  * [CResult], for a representation of an operation's outcome.
class CFutureController extends CController {
  /// Creates a controller to manage asynchronous tasks and their states.
  CFutureController({this.onStateChange});

  /// Called when the state of an asynchronous operation changes.
  final void Function(CFutureState state)? onStateChange;

  /// The current state of the asynchronous operation.
  var _state = CFutureState.success;

  /// Updates the state of the operation and informs listeners.
  void _updateState(CFutureState value) {
    _state = value;
    notify();
    onStateChange?.call(state);
  }

  /// Retrieves the current state of the asynchronous operation.
  CFutureState get state => _state;

  /// Executes an asynchronous operation and manages its state.
  Future<CResult<S, F>> run<S, F>(
    Future<CResult<S, F>> Function() task,
  ) async {
    if (state == CFutureState.inProgress) {
      log(
        "WARNING: A task is already running so states may become muddled up. Concider using two separate controllers for simultaneous tasks.",
        name: "CFutureController",
      );
    }
    _updateState(CFutureState.inProgress);

    final result = await task();

    final newState = switch (result) {
      CSuccess() => CFutureState.success,
      CFailure() => CFutureState.fail,
    };
    _updateState(newState);

    return result;
  }
}
