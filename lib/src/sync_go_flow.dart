// ignore_for_file: public_member_api_docs

import 'panic.dart';
import 'typedefs.dart';

class SyncGoFlow<T> {
  SyncGoFlow()
      : _deferredStack = [],
        _canDefer = true;
  static T? handle<T>(
    SyncDefferable<T> task,
  ) =>
      SyncGoFlow<T>().deferredCall(task);
  final List<SyncDefer<T>> _deferredStack;
  void _pushDefer(SyncDefer<T> task) {
    assert(_canDefer, '''
Do not use defer inside a defer.
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

  T? deferredCall(
    SyncDefferable<T> task,
  ) {
    try {
      _result = task(_pushDefer);
      _error = null;
    } on Object catch (e) {
      _result = null;
      _error = e;
    }
    _canDefer = false;

    for (final defer in _deferredStack) {
      try {
        _result = defer(
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
