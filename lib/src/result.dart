/// Represents the possible states of a [CResult].
enum CResultState {
  /// The result contains an error.
  error,

  /// The result's data is considered empty.
  empty,

  /// The result contains valid data.
  full,
}

/// Represents the outcome of an operation, including data or an error.
///
/// ### Example:
///
/// ``` dart
/// // 1. Create an operation that returns a CResult.
/// CResult<int> divide(int dividend, int divisor) {
///   // 2. Define a new result.
///   final result = CResult<int>(isEmpty: (data) => data! == 0);
///
///   try {
///     // 3. Add the data to the result.
///     result.data = dividend ~/ divisor;
///   } catch (error, stack) {
///     // 4. Add any errors to the result.
///     result.error = error;
///     result.stackTrace = stack;
///   }
///
///   // 5. Return the result.
///   return result;
/// }
///
/// // 6. Run the operation.
/// final result = divide(10, 2);
///
/// // 7. Do something according to the result.
/// switch (result.state) {
///   case CResultState.error:
///     print('Error: ${result.error}');
///     break;
///   case CResultState.empty:
///     print('Result: empty');
///     break;
///   case CResultState.full:
///     print('Result: ${result.data}');
/// }
/// ```
///
/// ### See also:
///  * [CResultState], for the possible states of a [CResult].
///  * [CController], base class providing lifecycle management for controllers.
///  * [CFutureController], for a controller that manages asynchronous tasks.
///  * [CObservable], for a class that makes values easy to share and observe.
///  * [CObserver], for a widget that updates its child whenever the value of a
///    [CObservable] changes.
///  * [CProvider], for a central hub for managing global instances with easy
///    access.
class CResult<T> {
  /// Creates a representation of an operation's outcome.
  CResult({
    this.data,
    this.error,
    this.stackTrace,

    /// A function to determine if the data is considered empty.
    bool Function(T? data)? isEmpty,
  }) : _isEmpty = isEmpty;

  /// The data contained within the result.
  T? data;

  /// The error object associated with the result.
  Object? error;

  /// The stack trace associated with the error, if applicable.
  StackTrace? stackTrace;

  /// A function to check if the data is considered empty.
  final bool Function(T? data)? _isEmpty;

  /// Returns `true` if the data is considered empty, `false` otherwise.
  ///
  /// Defaults to `false` if `isEmpty` wasn't provided during creation.
  bool get isEmpty => _isEmpty?.call(data) ?? false;

  /// Returns `true` if the result contains valid data, `false` otherwise.
  bool get hasData => !hasError && !isEmpty;

  /// Returns `true` if the result contains an error, `false` otherwise.
  bool get hasError => error != null || stackTrace != null;

  /// Provides a more readable state of the [CResult].
  ///
  /// This method consolidates logic, simplifying understanding, especially
  /// in switch statements. It returns a [CResultState] based on the outcome:
  ///  - [CResultState.error] if an error exists.
  ///  - [CResultState.empty] if data is considered empty.
  ///  - [CResultState.full] if valid data exists.
  CResultState get state {
    if (hasError) return CResultState.error;
    if (isEmpty) return CResultState.empty;
    return CResultState.full;
  }
}
