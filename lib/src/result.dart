/// Represents the generic result of an operation that can either succeed
/// or fail.
///
/// [CResult] is a sealed class with two subclasses:
///
/// - [CSuccess] is used when the operation succeeds. It contains the
///   successful result value.
///
/// - [CFailure] is used when the operation fails. It contains the failure
///   exception.
///
/// Using [CResult] allows representing both success and failure cases in a
/// type-safe way.
///
/// ### Example:
/// ``` dart
/// // 1. Create an operation that returns a CResult.
/// CResult<int, Exception> divide(int dividend, int divisor) {
///   try {
///     // 2. Return a success if the operation succeeds.
///     return CSuccess(dividend ~/ divisor, isEmpty: (value) => value == 0);
///   } on Exception catch (exception) {
///     // 3. Return a failure if the operation fails.
///     return CFailure(exception);
///   }
/// }
///
/// // 4. Run the operation.
/// final result = divide(10, 2);
///
/// // 5. Do something according to the result.
/// final handleResult = switch (result) {
///   CSuccess(value: final value) => () => print('Result: $value'),
///   CFailure(exception: final exception) => () => print('Error: $exception'),
/// };
/// handleResult();
/// ```
///
/// ### See also:
///  * [CSuccess], for representing a successful result value.
///  * [CFailure], for representing a failed result exception.
///  * [CController], base class providing lifecycle management for controllers.
///  * [CFutureController], for a controller that manages asynchronous tasks.
///  * [CObservable], for a class that makes values easy to share and observe.
///  * [CObserver], for a widget that updates its child whenever the value of a CObservable changes.
///  * [CProvider], for a central hub for managing global instances with easy access.
sealed class CResult<S, E extends Exception> {
  /// Creates the generic result of an operation that can either succeed or fail.
  const CResult();
}

/// [CSuccess] represents the success result of an operation.
///
/// It contains the [value] returned by the successful result.
///
/// An optional [isEmpty] function can be provided to check if the
/// result [value] should be considered empty.
final class CSuccess<S, E extends Exception> extends CResult<S, E> {
  /// Creates a [CSuccess] representing the success result of an operation.
  ///
  /// An optional [isEmpty] function can be provided to check if the
  /// result [value] should be considered empty.
  const CSuccess(
    this.value, {
    bool Function(S value)? isEmpty,
  }) : _isEmpty = isEmpty;

  /// The returned value of the successful result.
  final S value;

  /// A function to check if the value is considered empty.
  final bool Function(S value)? _isEmpty;

  /// Returns `true` if the value is considered empty, `false` otherwise.
  ///
  /// Defaults to `false` if `isEmpty` wasn't provided during creation.
  bool get isEmpty => _isEmpty?.call(value) ?? false;
}

/// [CFailure] represents the failure result of an operation.
///
/// It contains the [exception] thrown during the failure.
final class CFailure<S, E extends Exception> extends CResult<S, E> {
  /// Creates a [CFailure] representing the failure result of an operation.
  const CFailure(this.exception);

  /// The exception thrown during the failure.
  final E exception;
}
