import 'package:fpdart/fpdart.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_filter_entity.dart';
import 'package:rando_point_deau/features/water/domain/repository/water_repository_interface.dart';

interface class WaterSearchUseCase {

  final WaterRepositoryInterface repo;

  WaterSearchUseCase(this.repo);

  TaskEither<Failure, Success<List<WaterSourceEntity>>> call(WaterSourceFilterEntity filter) {
    return repo.search(filter);
  }

}