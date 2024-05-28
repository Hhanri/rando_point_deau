import 'package:fpdart/fpdart.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/features/water/domain/repository/water_repository_interface.dart';

interface class WaterDownloadAndSaveUseCase {

  final WaterRepositoryInterface repo;

  WaterDownloadAndSaveUseCase(this.repo);

  TaskEither<Failure, EmptySuccess> call() {
    return repo.downloadAndSave();
  }

}