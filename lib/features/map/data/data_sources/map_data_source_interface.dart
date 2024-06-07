import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

abstract interface class MapDataSourceInterface {
  Future<List<Water>> getFilters();
  Future<List<Water>> setFilters(List<Water> filters);
}
