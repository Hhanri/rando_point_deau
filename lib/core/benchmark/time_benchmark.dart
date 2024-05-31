import 'dart:async';

FutureOr<O> benchTime<I, O>({
  required I input,
  required FutureOr<O> Function(I input) transform,
  required String title,
}) async {
  print("------ $title --------");
  final start = DateTime.now();
  print("STARTING: $start");

  final res = await transform(input);

  final end = DateTime.now();
  print("ENDING: $end");
  print("TIME: ${end.millisecond - start.millisecond} ms");

  return res;
}
