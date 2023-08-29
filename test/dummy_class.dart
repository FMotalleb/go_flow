final class DummyClass {
  bool isClosed = false;
  bool get isOpen => !isClosed;
  int _counter = 0;
  int get counter => _counter;
  void dummySync() {
    _counter++;
  }

  Future<void> dummyASync() async {
    dummySync();
  }

  void closeSync() {
    isClosed = true;
  }

  Future<void> closeASync() async {
    closeSync();
  }
}
