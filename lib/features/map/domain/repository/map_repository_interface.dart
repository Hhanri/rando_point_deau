import 'package:fpdart/fpdart.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

abstract interface class MapRepositoryInterface {
  TaskEither<Failure, Success<List<Water>>> getFilters();
  TaskEither<Failure, Success<List<Water>>> setFilters(List<Water> filters);
}
