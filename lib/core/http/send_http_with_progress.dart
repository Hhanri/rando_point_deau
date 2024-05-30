import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rando_point_deau/core/http/http_methods.dart';

typedef Progress = ({
  num received,
  num total,
});

typedef ProgressCallback = void Function(Progress progress);

Future<T> sendHttpWithProgress<T>({
  required http.Client client,
  required HttpMethod method,
  required String url,
  required T Function(String) bodyTransformer,
  ProgressCallback? progressCallback,
}) async {
  final List<int> bytes = [];

  final response = await client.send(
    http.Request(
      method.toString(),
      Uri.parse(url),
    ),
  );

  final total = response.contentLength ?? double.maxFinite;
  int received = 0;

  await response.stream.forEach((value) {
    bytes.addAll(value);
    received += value.length;

    final Progress progress = (received: received, total: total);
    progressCallback?.call(progress);
  });

  final body = utf8.decode(bytes);
  return bodyTransformer(body);
}
