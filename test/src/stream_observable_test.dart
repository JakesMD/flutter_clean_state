import 'package:clean_state/src/stream_observable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CStreamObservable Tests', () {
    test('Should construct.', () {
      CStreamObservable(const Stream.empty());
    });

    test('value should be the initial value to start with if provided.', () {
      expect(CStreamObservable(const Stream<int>.empty(), value: 1).value, 1);
    });

    test('value should update on stream event.', () async {
      final stream = Stream.periodic(
        const Duration(milliseconds: 10),
        (x) => x,
      );

      final observable = CStreamObservable(stream);
      expect(observable.value, null);

      await Future.delayed(const Duration(milliseconds: 15));
      expect(observable.value, 0);
    });

    test('stream should notify listeners when value updates.', () async {
      final stream = Stream.periodic(
        const Duration(milliseconds: 10),
        (x) => x,
      );

      final observable = CStreamObservable(stream);
      late int result;
      observable.stream.listen((value) => result = value);

      await Future.delayed(const Duration(milliseconds: 15));
      expect(result, 0);
    });
  });

  group('CStreamObservableExtension Tests', () {
    test('Should create a StreamObservable.', () {
      final result = const Stream<int>.empty().cObserve;
      expect(result, isA<CStreamObservable<int?>>());
    });

    test('Should create a seeded StreamObservable.', () {
      final result = const Stream<int>.empty().cObserveSeeded(1);
      expect(result, isA<CStreamObservable<int?>>());
      expect(result.value, 1);
    });
  });
}
