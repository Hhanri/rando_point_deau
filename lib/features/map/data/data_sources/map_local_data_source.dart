import 'package:rando_point_deau/features/map/data/data_sources/map_data_source_interface.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class MapLocalDataSource implements MapDataSourceInterface {
  final SharedPreferences prefs;

  MapLocalDataSource(this.prefs);
  @override
  Future<List<Water>> getFilters() async {
    final res = prefs.getStringList("filters");
    return res?.map(Water.defaultParse).toList() ?? Water.values;
  }

  @override
  Future<List<Water>> setFilters(List<Water> filters) async {
    await prefs.setStringList(
      "filters",
      filters.map((e) => e.name).toList(),
    );

    return filters;
  }
}
