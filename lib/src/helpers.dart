import 'async_go_flow.dart';
import 'sync_go_flow.dart';
import 'typedefs.dart';

Future<T?> asyncGoFlow<T>(
  ASyncDefferable<T> task,
) =>
    AsyncGoFlow.handle<T>(task);

T? syncGoFlow<T>(
  SyncDefferable<T> task,
) =>
    SyncGoFlow.handle<T>(task);
