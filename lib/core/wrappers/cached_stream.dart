import 'dart:async';

final class CachedStream<T> extends Stream<T> {
  final Stream<T> stream;
  final T defaultValue;

  T? _mostRecent;

  T get mostRecent => _mostRecent ?? defaultValue;

  CachedStream(this.stream, {required this.defaultValue});

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return stream.asBroadcastStream().listen(
      (event) {
        _mostRecent = event;
        onData?.call(event);
      },
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
