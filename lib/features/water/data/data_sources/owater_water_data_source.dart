import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rando_point_deau/features/water/data/data_sources/water_remote_data_source_interface.dart';
import 'package:rando_point_deau/features/water/data/models/owater_water_source_model.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';

final class OwaterWaterDataSource implements WaterRemoteDataSourceInterface {
  final http.Client client;

  OwaterWaterDataSource(this.client);

  @override
  Future<List<WaterSourceEntity>> getAllWaterSources() async {
    final List<int> bytes = [];

    final response = await client.send(
      http.Request(
        'GET',
        Uri.parse(
          "https://owaterorg.gogocarto.fr/api/elements.json?categories=5,6&excludeExternal=true",
        ),
      ),
    );
    final total = response.contentLength;
    int received = 0;

    await response.stream.forEach((value) {
      bytes.addAll(value);
      received += value.length;
    });

    final body = utf8.decode(bytes);
    final Map<String, dynamic> json = jsonDecode(body);
    final List<dynamic> data = json['data'];

    return data
        .map<OwaterWaterSourceModel>((e) => OwaterWaterSourceModel.fromJson(e))
        .toList();
  }
}
