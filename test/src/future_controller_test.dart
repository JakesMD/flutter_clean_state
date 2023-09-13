import 'package:clean_state/clean_state.dart';
import 'package:flutter_test/flutter_test.dart';

const operationDuration = Duration(milliseconds: 10);
const success = CSuccess('Success!');
final failure = CFailure(Exception('Failure'));

// Create a test async function that returns a success.
Future<CResult> testAsyncFnSuccess() async {
  await Future.delayed(operationDuration);
  return success;
}

// Create a test async function that returns a failure.
Future<CResult> testAsyncFnFail() async {
  await Future.delayed(operationDuration);
  return failure;
}

void main() {
  late CFutureController controller;

  setUp(() {
    controller = CFutureController();
  });

  group('CFutureController Tests', () {
    test('Should be in progress state during operation.', () async {
      expect(controller.state, CFutureState.success);

      controller.run(() => testAsyncFnSuccess());
      expect(controller.state, CFutureState.inProgress);

      await Future.delayed(operationDuration);
      expect(controller.state, CFutureState.success);
    });

    test('Should return a success with success state.', () async {
      final result = await controller.run(() => testAsyncFnSuccess());

      expect(result, success);
      expect(controller.state, CFutureState.success);
    });

    test('Should return a failure with fail state.', () async {
      final result = await controller.run(() => testAsyncFnFail());

      expect(result, failure);
      expect(controller.state, CFutureState.fail);
    });
  });
}
