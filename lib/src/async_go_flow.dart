import 'dart:async';

import 'panic.dart';
import 'typedefs.dart';

class AsyncGoFlow<T> {
  AsyncGoFlow() : _differedStack = [];

  static Future<T?> handle<T>(
    ASyncDefferable<T> task,
  ) =>
      AsyncGoFlow<T>().deferredCall(task);
  final List<ASyncDefer<T>> _differedStack;
  void _pushDiffer(ASyncDefer<T> task) => _differedStack.add(task);
  Object? _error;
  E? _recover<E extends Object?>() {
    final err = _error;
    if (err is E) {
      _error = null;
      return err;
    }
    return null;
  }

  T? _result;
  T? _getResult() {
    final res = _result;
    _result = null;
    return res;
  }

  Future<T?> deferredCall(
    ASyncDefferable<T> task,
  ) async {
    try {
      _result = await task(_pushDiffer);
      _error = null;
    } catch (e) {
      _result = null;
      _error = e;
    }

    for (final differ in _differedStack.reversed) {
      try {
        _result = await differ(
              _getResult,
              _recover,
            ) ??
            _result;
      } catch (e) {
        _error = e;
      }
    }
    final error = _recover<Object>();
    if (error != null) {
      throw Panic(
        message: 'flow done with an exception in the stack',
        error: error,
      );
    }
    return _getResult();
  }
}
