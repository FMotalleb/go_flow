import 'dart:async';

typedef GetterMethod<E extends Object?> = E? Function();
typedef GenericGetterMethod = E? Function<E extends Object?>();

typedef ASyncDefer<T> = FutureOr<T?> Function(
  GetterMethod<T> result,
  GenericGetterMethod recover,
);

typedef SyncDefer<T> = T? Function(
  GetterMethod<T> result,
  GenericGetterMethod recover,
);

typedef ASyncDefferable<T> = FutureOr<T?> Function(
  void Function(ASyncDefer<T>) defer,
);
typedef SyncDefferable<T> = T? Function(
  void Function(SyncDefer<T>) defer,
);
