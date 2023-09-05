/// {@template panic}
/// An Unhandled exception that did not get caught inside a deffer statement
/// {@endtemplate}
class Panic implements Exception {
  /// {@macro panic}
  Panic({
    required this.message,
    required this.error,
  });

  /// Object that forced this panic to happen
  ///
  /// normally item
  final Object error;

  /// Panic message
  final String message;
  @override
  String toString() {
    return '''
Panic: $message
$error''';
  }
}
