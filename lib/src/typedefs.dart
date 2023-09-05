import 'dart:async';

/// Simple getter method that returns `E`
typedef GetterMethod<E extends Object?> = E? Function();

/// used as recovery method to indicate what kind of error to recover from
///
/// e.g.: recover<Exception>()
typedef GenericGetterMethod = E? Function<E extends Object?>();

/// Signature of AsyncDeffer that has two parameters a getter that returns
/// result (`result()`) and recover parameter that returns exception of the
/// given type (`recover<type>()`)
typedef ASyncDefer<T> = FutureOr<T?> Function(
  GetterMethod<T> result,
  GenericGetterMethod recover,
);

/// Signature of SyncDeffer that has two parameters a getter that returns
/// result (`result()`) and recover parameter that returns exception of the
/// given type (`recover<type>()`)
typedef SyncDefer<T> = T? Function(
  GetterMethod<T> result,
  GenericGetterMethod recover,
);

/// Signature of ASyncDefferable task that has a parameter: [defer]
/// that can be used to schedule a task to be executed after scope exits
typedef ASyncDefferable<T> = FutureOr<T?> Function(
  void Function(ASyncDefer<T>) defer,
);

/// Signature of SyncDefferable task that has a parameter: [defer]
/// that can be used to schedule a task to be executed after scope exits
typedef SyncDefferable<T> = T? Function(
  void Function(SyncDefer<T>) defer,
);
