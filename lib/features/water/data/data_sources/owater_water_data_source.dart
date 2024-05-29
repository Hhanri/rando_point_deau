import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rando_point_deau/core/http/http_methods.dart';
import 'package:rando_point_deau/core/http/send_http_with_progress.dart';
import 'package:rando_point_deau/features/water/data/data_sources/water_remote_data_source_interface.dart';
import 'package:rando_point_deau/features/water/data/models/owater_water_source_model.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';

final class OwaterWaterDataSource implements WaterRemoteDataSourceInterface {
  final http.Client client;

  OwaterWaterDataSource(this.client);

  @override
  Future<List<WaterSourceEntity>> getAllWaterSources({
    ProgressCallback? progressCallback,
  }) async {
    const url =
        "https://owaterorg.gogocarto.fr/api/elements.json?categories=5,6&excludeExternal=true";

    return sendHttpWithProgress<List<WaterSourceEntity>>(
      client: client,
      method: HttpMethod.get,
      url: url,
      bodyTransformer: (body) {
        final Map<String, dynamic> json = jsonDecode(body);
        final List<dynamic> data = json['data'];

        return data
            .map<OwaterWaterSourceModel>(
              (e) => OwaterWaterSourceModel.fromJson(e),
            )
            .toList();
      },
      progressCallback: progressCallback,
    );
  }
}
