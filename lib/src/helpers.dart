import 'async_go_flow.dart';
import 'sync_go_flow.dart';
import 'typedefs.dart';

/// This function sets up a context in which you can define actions
/// to be executed when the current scope exits.
///
/// It takes a callback function as an argument,
/// often referred to as the defer function.
///
/// This defer function can accept two parameters: result and recover.
/// These parameters are functions that you can call within the defer context,
/// once you receive value from either of these functions they will return null
/// afterwards so keep in mind that result of this function will be the same as
/// result() in first deffer so if you call `result` function in a defer
/// you have to return a value in that defer or `result` will be lost dus
/// make this function return null
Future<T?> asyncGoFlow<T>(
  ASyncDefferable<T> task,
) =>
    AsyncGoFlow.handle<T>(task);

/// This function sets up a context in which you can define actions
/// to be executed when the current scope exits.
///
/// It takes a callback function as an argument,
/// often referred to as the defer function.
///
/// This defer function can accept two parameters: result and recover.
/// These parameters are functions that you can call within the defer context,
/// once you receive value from either of these functions they will return null
/// afterwards so keep in mind that result of this function will be the same as
/// result() in first deffer so if you call `result` function in a defer
/// you have to return a value in that defer or `result` will be lost dus
/// make this function return null
T? syncGoFlow<T>(
  SyncDefferable<T> task,
) =>
    SyncGoFlow.handle<T>(task);
