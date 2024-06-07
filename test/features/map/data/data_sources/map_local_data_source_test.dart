import 'package:flutter_test/flutter_test.dart';
import 'package:rando_point_deau/features/map/data/data_sources/map_local_data_source.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

import '../../../../test_setup/shared_preferences.dart';

void main() async {
  final prefs = await setupSharedPreferencesTest();
  final dataSource = MapLocalDataSource(prefs);

  group("map local data source test", () {
    group("get filters", () {
      setUpAll(prefs.clear);

      test("no filter", () async {
        final res = await dataSource.getFilters();
        expect(res, Water.values);
      });

      test("one filter", () async {
        await prefs.setStringList("filters", [Water.drinking.name]);

        final res = await dataSource.getFilters();
        expect(res, [Water.drinking]);
      });

      test("all filters", () async {
        await prefs.setStringList(
          "filters",
          Water.values.map((e) => e.name).toList(),
        );

        final res = await dataSource.getFilters();
        expect(res, Water.values);
      });
    });

    group("set filers", () {
      setUpAll(prefs.clear);

      test("set no filter", () async {
        final res = await dataSource.setFilters([]);

        expect(res, []);

        expect(prefs.getStringList("filters"), []);
      });

      test("set one filter", () async {
        final res = await dataSource.setFilters([Water.nonDrinkable]);

        expect(res, [Water.nonDrinkable]);

        expect(prefs.getStringList("filters"), [Water.nonDrinkable.name]);
      });

      test("set all filters", () async {
        final res = await dataSource.setFilters(Water.values);

        expect(res, Water.values);

        expect(
          prefs.getStringList("filters"),
          Water.values.map((e) => e.name).toList(),
        );
      });
    });
  });
}
