// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'panic.dart';
import 'typedefs.dart';

class AsyncGoFlow<T> {
  AsyncGoFlow()
      : _deferredStack = [],
        _canDefer = true;

  static Future<T?> handle<T>(
    ASyncDefferable<T> task,
  ) =>
      AsyncGoFlow<T>().deferredCall(task);
  final List<ASyncDefer<T>> _deferredStack;
  void _pushDeffer(ASyncDefer<T> task) {
    assert(_canDefer, '''
Do not use defer inside a deffer.
To use defer inside a defer you have to create new flow.''');
    _deferredStack.insert(0, task);
  }

  bool _canDefer;
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
      _result = await task(_pushDeffer);
      _error = null;
    } on Object catch (e) {
      _result = null;
      _error = e;
    }
    _canDefer = false;
    for (final defer in _deferredStack.reversed) {
      try {
        _result = await defer(
              _getResult,
              _recover,
            ) ??
            _result;
      } on Object catch (e) {
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
