/// This package aims to bring a deferred execution mechanism similar to
/// Golang's defer statement into the Dart programming language.
/// This mechanism allows you to schedule code to run when a certain scope or
/// function exits, ensuring that necessary cleanup or finalization tasks are
/// performed regardless of how the scope exits
/// (either normally or due to an error).
library;

export 'src/helpers.dart';
export 'src/panic.dart';
export 'src/typedefs.dart';
