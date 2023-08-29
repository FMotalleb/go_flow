## Go Flow

This package aims to bring a deferred execution mechanism similar to Go's defer statement into the Dart programming language. This mechanism allows you to schedule code to run when a certain scope or function exits, ensuring that necessary cleanup or finalization tasks are performed regardless of how the scope exits (either normally or due to an error).

this package provides you with two functions for use within your application:

1. `syncGoFlow`
2. `asyncGoFlow`

As a simple example:

```go
func main() {
    file := File("test")
    defer:
        file.Close()
    file.Write("text")
}
```

This can be implemented using this package as:

```dart
syncGoFlow((defer) {
  final io = File("test").openSync(mode: FileMode.append);
  defer((result, recover) {
    io.closeSync();
  });
  io.writeStringSync('text');
});
```

The `result` and `recover` parameters given in the defer statement are not lazy, but they are functions, and once you call them, they will return null afterward. So, if you call `result` inside a defer statement, you have to return something if you don't want to receive null.

### Execution order

One of the key features of this mechanism is the execution order of deferred actions, which follows a Last-In-First-Out (LIFO) pattern.

>the LIFO principle means that the order in which deferred actions are executed is the reverse of the order in which they are defined. The most recently defined deferred action will be the first one to execute when the scope exits, and the earliest defined deferred action will be the last one to execute.

```dart
syncGoFlow((defer) {
  // This will be executed last when the scope exits
  defer((result, recover) {
    // Clean up or finalize action
  });
  
  // ... Other code and defer statements ...
  
  // This will be executed first when the scope exits
  defer((result, recover) {
    // Clean up or finalize action
  });
});
```

This order ensures that the most recently defined deferred action has the opportunity to perform any cleanup or finalization before the earlier defined actions.
