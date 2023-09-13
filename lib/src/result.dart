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
/// ```dart
/// CResult<int, Exception> divide(int dividend, int divisor) { // 1. Create an operation that returns a CResult.
///   try {
///     return CSuccess(dividend ~/ divisor, isEmpty: (value) => value == 0); // 2. Return a success...
///   } on Exception catch (exception) {
///     return CFailure(exception); // 3. Or a failure.
///   }
/// }
///
/// final result = divide(10, 2); // 4. Run the operation.
///
/// final handleResult = switch (result) { // 5. Do something according to the result.
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
sealed class CResult<S, F> {
  /// Creates the generic result of an operation that can either succeed or fail.
  const CResult();
}

/// [CSuccess] represents the success result of an operation.
///
/// It contains the [value] returned by the successful result.
///
/// An optional [isEmpty] function can be provided to check if the
/// result [value] should be considered empty.
final class CSuccess<S, F> extends CResult<S, F> {
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
final class CFailure<S, F> extends CResult<S, F> {
  /// Creates a [CFailure] representing the failure result of an operation.
  const CFailure(this.exception);

  /// The exception thrown during the failure.
  final F exception;
}
