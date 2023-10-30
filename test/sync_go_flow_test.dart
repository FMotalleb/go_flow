// ignore_for_file: lines_longer_than_80_chars

import 'package:go_flow/go_flow.dart';
import 'package:test/test.dart';

import 'dummy_class.dart';

void main() {
  group('[SyncFlow]', () {
    var dummyItem = DummyClass();
    setUp(() {
      dummyItem = DummyClass();
    });

    test(
      'Check Initiation',
      () {
        final count = syncGoFlow<int>(
          (defer) {
            dummyItem.dummySync();
            return dummyItem.counter;
          },
        );
        expect(count, const TypeMatcher<int>());
        expect(count, equals(1));
      },
    );
    test(
      'Check Defer statement with null return',
      () {
        final count = syncGoFlow<int>(
          (defer) {
            defer(
              (result, recover) {
                dummyItem.dummySync();
                return null;
              },
            );
            dummyItem.dummySync();
            return dummyItem.counter;
          },
        );
        expect(count, const TypeMatcher<int>());
        expect(count, equals(1));
      },
    );
    test(
      'Check Nested Defer should panic',
      () {
        int? count() => syncGoFlow<int>(
              (defer) {
                defer(
                  (result, recover) {
                    defer(
                      (result, recover) {
                        dummyItem.dummySync();
                        return null;
                      },
                    );
                    dummyItem.dummySync();
                    return null;
                  },
                );
                dummyItem.dummySync();
                return dummyItem.counter;
              },
            );
        expect(count, throwsA(const TypeMatcher<Panic>()));
      },
    );
    test(
      'Check Defer statement with exception thrown',
      () {
        int? count() => syncGoFlow<int>(
              (defer) {
                defer(
                  (result, recover) {
                    dummyItem.dummySync();
                    throw Exception('inside deffer');
                  },
                );
                dummyItem.dummySync();
                return dummyItem.counter;
              },
            );
        expect(count, throwsException);
      },
    );
    test(
      'Check Defer statement with null return but calling result before returning',
      () {
        final count = syncGoFlow<int>(
          (defer) {
            defer(
              (result, recover) {
                dummyItem.dummySync();
                result();
                return null;
              },
            );
            dummyItem.dummySync();
            return dummyItem.counter;
          },
        );
        expect(count, const TypeMatcher<void>());
        expect(count, equals(null));
      },
    );
    test(
      'Check Defer statement with value return',
      () {
        final count = syncGoFlow<int>(
          (defer) {
            defer(
              (result, recover) {
                dummyItem.dummySync();
                return dummyItem.counter;
              },
            );
            dummyItem.dummySync();
            return dummyItem.counter;
          },
        );
        expect(count, const TypeMatcher<int>());
        expect(count, equals(2));
      },
    );
    test(
      'Check Defer statement with capture exception',
      () {
        final count = syncGoFlow<int>(
          (defer) {
            defer(
              (result, recover) {
                dummyItem.dummySync();
                recover();
                return dummyItem.counter;
              },
            );
            dummyItem.dummySync();
            throw Exception('test');
          },
        );
        expect(count, const TypeMatcher<int>());
        expect(count, equals(2));
      },
    );
    test(
      'Check Defer statement with capture exception (incorrect type)',
      () {
        int? count() => syncGoFlow<int>(
              (defer) {
                defer(
                  (result, recover) {
                    dummyItem.dummySync();
                    recover<int>();
                    return dummyItem.counter;
                  },
                );
                dummyItem.dummySync();
                throw Exception('test');
              },
            );

        expect(count, throwsException);
        // expect(count, equals(2));
      },
    );
    test(
      'Check Defer statement (Order of execution)',
      () {
        final count = syncGoFlow<List<int>>(
          (defer) {
            final item = <int>[1];
            defer(
              (result, recover) {
                return [...result()!, 2];
              },
            );
            item.add(3);
            defer(
              (result, recover) {
                return [...result()!, 4];
              },
            );
            item.add(5);
            return item;
          },
        );
        expect(count, const TypeMatcher<List<int>>());
        expect(count, equals([1, 3, 5, 4, 2]));
      },
    );
  });
}
