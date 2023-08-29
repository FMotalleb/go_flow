import 'package:go_flow/go_flow.dart';
import 'package:test/test.dart';

void main() {
  test('initiation panic', () {
    final panic = Panic(message: 'test', error: Exception('exception'));
    expect(panic.toString(), contains('test'));
    expect(panic.toString(), contains('exception'));
    expect(panic.toString(), contains('Exception'));
  });
}
