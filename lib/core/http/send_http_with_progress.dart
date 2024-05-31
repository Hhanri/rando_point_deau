import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rando_point_deau/core/http/http_methods.dart';
import 'package:rando_point_deau/core/value_objects/progress.dart';

final class StringWrapper {
  String _value;

  StringWrapper(this._value);

  String get value => _value;

  void clear() {
    _value = "";
  }
}

Future<T> sendHttpWithProgress<T>({
  required http.Client client,
  required HttpMethod method,
  required String url,
  required FutureOr<T> Function(StringWrapper) bodyTransformer,
  ProgressCallback? progressCallback,
  num defaultTotal = double.maxFinite,
  StepProgress? stepProgress,
}) async {
  final List<int> bytes = [];

  final response = await client.send(
    http.Request(
      method.toString(),
      Uri.parse(url),
    ),
  );

  final total = response.contentLength ?? defaultTotal;
  int received = 0;

  await response.stream.forEach((value) {
    bytes.addAll(value);
    received += value.length;

    final Progress progress = Progress.httpDownload(
      progress: received,
      total: total,
      stepProgress: stepProgress,
    );
    progressCallback?.call(progress);
  });

  final body = utf8.decode(bytes);
  bytes.clear();
  return await bodyTransformer(StringWrapper(body));
}
