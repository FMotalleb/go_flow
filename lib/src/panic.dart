/// An Unhandled exception that did not get caught inside a deffer statement
class Panic implements Exception {
  Panic({
    required this.message,
    required this.error,
  });

  final Object? error;
  final String message;
  @override
  String toString() {
    return '''
Panic: $message
$error''';
  }
}
