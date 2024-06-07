import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef ComputeMessage<T> = ({RootIsolateToken token, T data});

typedef IsolateParam<T> = ({T data, SendPort sendPort});

typedef IsolateMessage<T> = ({
  FutureOr<void> Function(IsolateParam<T> message) callback,
  IsolateParam<T> param,
  RootIsolateToken token,
});

void initIsolate(RootIsolateToken token) {
  BackgroundIsolateBinaryMessenger.ensureInitialized(token);
}

Future<O> runCompute<T, O>(
  Future<O> Function(ComputeMessage<T> message) func,
  T data,
) {
  final ComputeMessage<T> message = (
    token: RootIsolateToken.instance!,
    data: data,
  );

  return compute(
    (message) {
      initIsolate(message.token);
      return func(message);
    },
    message,
  );
}

typedef IsolateListenCallback = void Function(
  Object? message,
  Completer<void> completer,
);

Future<void> spawnIsolate<T>(
  FutureOr<void> Function(IsolateParam<T> message) func,
  T data, {
  required IsolateListenCallback listenCallback,
}) async {
  final mainPort = ReceivePort("main");
  final IsolateParam<T> param = (
    data: data,
    sendPort: mainPort.sendPort,
  );
  final IsolateMessage<T> message = (
    param: param,
    callback: func,
    token: RootIsolateToken.instance!,
  );

  final completer = Completer<void>();

  final isolate = await Isolate.spawn(
    (message) async {
      initIsolate(message.token);
      await message.callback(message.param);
    },
    message,
  );

  mainPort.listen(
    (message) => listenCallback(message, completer),
  );

  await completer.future;
  isolate.kill();
  mainPort.close();
}
