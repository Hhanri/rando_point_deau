import 'package:rando_point_deau/core/http/send_http_with_progress.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';

abstract interface class WaterRemoteDataSourceInterface {
  Future<List<WaterSourceEntity>> getAllWaterSources({
    ProgressCallback? progressCallback,
  });
}
