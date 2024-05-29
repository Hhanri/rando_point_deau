import 'package:fpdart/fpdart.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/features/water/data/data_sources/water_local_data_source_interface.dart';
import 'package:rando_point_deau/features/water/data/data_sources/water_remote_data_source_interface.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_filter_entity.dart';
import 'package:rando_point_deau/features/water/domain/repository/water_repository_interface.dart';

final class WaterRepositoryImplementation implements WaterRepositoryInterface {
  final WaterLocalDataSourceInterface localDataSource;
  final WaterRemoteDataSourceInterface remoteDataSource;

  WaterRepositoryImplementation({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  TaskEither<Failure, EmptySuccess> downloadAndSave() {
    return execute(() async {
      final sources = await remoteDataSource.getAllWaterSources();
      return await localDataSource.insertWaterSources(sources);
    });
  }

  @override
  TaskEither<Failure, Success<bool>> hasLocalData() {
    return execute(localDataSource.hasData);
  }

  @override
  TaskEither<Failure, Success<List<WaterSourceEntity>>> search(
    WaterSourceFilterEntity filter,
  ) {
    return execute(
      () => filter.bounds.isCrossAntiMeridian
          ? localDataSource.getWrapAround(filter)
          : localDataSource.get(filter),
    );
  }
}
