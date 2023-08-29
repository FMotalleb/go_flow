// ignore_for_file: lines_longer_than_80_chars

import 'package:go_flow/go_flow.dart';
import 'package:test/test.dart';

import 'dummy_class.dart';

void main() {
  group('[ASyncFlow]', () {
    var dummyItem = DummyClass();
    setUp(() {
      dummyItem = DummyClass();
    });

    test(
      'Check Initiation',
      () async {
        final count = await asyncGoFlow<int>(
          (defer) {
            dummyItem.dummyASync();
            return dummyItem.counter;
          },
        );
        expect(count, const TypeMatcher<int>());
        expect(count, equals(1));
      },
    );
    test(
      'Check Defer statement with null return',
      () async {
        final count = await asyncGoFlow<int>(
          (defer) async {
            defer(
              (result, recover) async {
                await dummyItem.dummyASync();
                return null;
              },
            );
            await dummyItem.dummyASync();
            return dummyItem.counter;
          },
        );
        expect(count, const TypeMatcher<int>());
        expect(count, equals(1));
      },
    );
    test(
      'Check Defer statement with exception thrown',
      () {
        Future<int?> count() => asyncGoFlow<int>(
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
      () async {
        final count = await asyncGoFlow<int>(
          (defer) {
            defer(
              (result, recover) {
                dummyItem.dummyASync();
                result();
                return null;
              },
            );
            dummyItem.dummyASync();
            return dummyItem.counter;
          },
        );
        expect(count, const TypeMatcher<void>());
        expect(count, equals(null));
      },
    );
    test(
      'Check Defer statement with value return',
      () async {
        final count = await asyncGoFlow<int>(
          (defer) {
            defer(
              (result, recover) {
                dummyItem.dummyASync();
                return dummyItem.counter;
              },
            );
            dummyItem.dummyASync();
            return dummyItem.counter;
          },
        );
        expect(count, const TypeMatcher<int>());
        expect(count, equals(2));
      },
    );
    test(
      'Check Defer statement with capture exception',
      () async {
        final count = await asyncGoFlow<int>(
          (defer) {
            defer(
              (result, recover) {
                dummyItem.dummyASync();
                recover();
                return dummyItem.counter;
              },
            );
            dummyItem.dummyASync();
            throw Exception('test');
          },
        );
        expect(count, const TypeMatcher<int>());
        expect(count, equals(2));
      },
    );
    test(
      'Check Defer statement with capture exception (incorrect type)',
      () async {
        Future<void> count() => asyncGoFlow<int>(
              (defer) {
                defer(
                  (result, recover) {
                    dummyItem.dummyASync();
                    recover<int>();
                    return dummyItem.counter;
                  },
                );
                dummyItem.dummyASync();
                throw Exception('test');
              },
            );

        expect(count, throwsException);
        // expect(count, equals(2));
      },
    );
    test(
      'Check Defer statement (Order of execution)',
      () async {
        final count = await asyncGoFlow<List<int>>(
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
