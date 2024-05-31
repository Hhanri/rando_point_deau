import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/core/value_objects/progress.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_filter_entity.dart';

abstract interface class WaterLocalDataSourceInterface {
  Future<Empty> insertWaterSources(
    List<WaterSourceEntity> waterSources, {
    ProgressCallback? progressCallback,
    StepProgress? stepProgress,
  });

  Future<List<WaterSourceEntity>> get(WaterSourceFilterEntity filter);

  Future<List<WaterSourceEntity>> getWrapAround(WaterSourceFilterEntity filter);

  Future<bool> hasData();
}
