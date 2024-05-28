import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';

abstract interface class WaterRemoteDataSourceInterface {

  Future<List<WaterSourceEntity>> getAllWaterSources();

}