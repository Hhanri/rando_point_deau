import 'package:fpdart/fpdart.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/features/water/domain/repository/water_repository_interface.dart';

interface class WaterHasLocalDataUseCase {

  final WaterRepositoryInterface repo;

  WaterHasLocalDataUseCase(this.repo);

  TaskEither<Failure, Success<bool>> call() {
    return repo.hasLocalData();
  }

}