import 'package:fpdart/fpdart.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/features/map/data/data_sources/map_data_source_interface.dart';
import 'package:rando_point_deau/features/map/domain/repository/map_repository_interface.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

final class MapRepositoryImplementation implements MapRepositoryInterface {
  final MapDataSourceInterface dataSource;

  MapRepositoryImplementation(this.dataSource);

  @override
  TaskEither<Failure, Success<List<Water>>> getFilters() {
    return execute(() => dataSource.getFilters());
  }

  @override
  TaskEither<Failure, Success<List<Water>>> setFilters(List<Water> filters) {
    return execute(() => dataSource.setFilters(filters));
  }
}
