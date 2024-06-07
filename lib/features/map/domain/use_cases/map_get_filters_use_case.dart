import 'package:fpdart/fpdart.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/features/map/domain/repository/map_repository_interface.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

interface class MapGetFiltersUseCase {
  final MapRepositoryInterface repo;

  MapGetFiltersUseCase(this.repo);
  TaskEither<Failure, Success<List<Water>>> call() {
    return repo.getFilters();
  }
}
