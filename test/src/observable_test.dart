import 'package:clean_state/clean_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CObservable Tests', () {
    test('Should construct.', () {
      CObservable(1.0);
    });

    test('value should be the initial value to start with.', () {
      expect(CObservable(1).value, 1);
    });

    test('value should update when set.', () {
      final observable = CObservable(1);
      expect(observable.value, 1);

      observable.value = 2;
      expect(observable.value, 2);
    });

    test('stream should notify listeners when value updates.', () async {
      final observable = CObservable(1);
      late int result;
      observable.stream.listen((value) => result = value);

      observable.value = 2;
      await Future.delayed(const Duration(milliseconds: 10));
      expect(result, 2);
    });

    test('notify should notify stream listeners.', () async {
      final observable = CObservable(1);
      late int result;
      observable.stream.listen((value) => result = value);

      observable.notify();
      await Future.delayed(const Duration(milliseconds: 10));
      expect(result, 1);
    });
  });
  group('CObservableExtension Tests', () {
    test('Should create an observable.', () {
      final result = 1.cObserve;
      expect(result, isA<CObservable<int>>());
      expect(result.value, 1);
    });
  });
}
