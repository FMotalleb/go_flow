import 'panic.dart';
import 'typedefs.dart';

class SyncGoFlow<T> {
  SyncGoFlow() : _differedStack = [];
  static T? handle<T>(
    SyncDefferable<T> task,
  ) =>
      SyncGoFlow<T>().deferredCall(task);
  final List<SyncDefer<T>> _differedStack;
  void _pushDiffer(SyncDefer<T> task) => _differedStack.add(task);
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
      _result = task(_pushDiffer);
      _error = null;
    } catch (e) {
      _result = null;
      _error = e;
    }

    for (final differ in _differedStack.reversed) {
      try {
        _result = differ(
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
