import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';

final class MockHttpClient extends Mock implements http.Client {}

http.Response httpResponseFromObject(Object response, int statusCode) {
  return http.Response.bytes(utf8.encode(jsonEncode(response)), statusCode);
}

http.Client mockStreamedResponseClient(String body) {
  return MockClient.streaming((request, _) async {
    return http.StreamedResponse(Stream.value(utf8.encode(body)), 200);
  });
}
