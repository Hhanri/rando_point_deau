import 'package:flutter_test/flutter_test.dart';
import 'package:rando_point_deau/core/db/sqflite_setup.dart';
import 'package:rando_point_deau/core/value_objects/geopoint.dart';
import 'package:rando_point_deau/features/water/data/data_sources/sqfite_water_data_source.dart';
import 'package:rando_point_deau/features/water/data/models/sqflite_water_source_model.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_filter_entity.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

import '../../../../core/db/sqflite_setup.dart';

main() async {
  final db = await sqfliteTestDb();
  final dataSource = SQFliteWaterDataSource(db);

  group("sqlfite water data source test", () {
    group("has data", () {
      tearDownAll(clearTestDb(db));

      test("empty db", () async {
        final res = await dataSource.hasData();
        expect(res, false);
      });

      test("non empty db", () async {
        const sample = SQFliteWaterSourceModel(
          id: "id",
          name: "name",
          geoPoint: GeoPoint(lat: 2, lng: 3),
          waterType: Water.drinking,
        );

        await db.insert(SQFliteConfig.waterSourcesTable, sample.toJson());

        final res = await dataSource.hasData();
        expect(res, true);
      });
    });

    group("insert", () {
      tearDownAll(clearTestDb(db));

      test("insert", () async {
        const sample = [
          SQFliteWaterSourceModel(
            id: "id1",
            name: "name1",
            geoPoint: GeoPoint(lat: 2, lng: 3),
            waterType: Water.drinking,
          ),
          SQFliteWaterSourceModel(
            id: "id2",
            name: "name2",
            geoPoint: GeoPoint(lat: -2, lng: -3),
            waterType: Water.drinking,
          ),
        ];

        await dataSource.insertWaterSources(sample);

        final inserted = await db.query(SQFliteConfig.waterSourcesTable);

        expect(inserted, unorderedEquals(sample.map((e) => e.toJson())));
      });
    });

    group("get", () {
      const sample1 = SQFliteWaterSourceModel(
        id: "id1",
        name: "name1",
        geoPoint: GeoPoint(lat: 30, lng: -130),
        waterType: Water.drinking,
      );

      const sample2 = SQFliteWaterSourceModel(
        id: "id2",
        name: "name2",
        geoPoint: GeoPoint(lat: 0, lng: 0),
        waterType: Water.drinking,
      );

      const sample3 = SQFliteWaterSourceModel(
        id: "id3",
        name: "name3",
        geoPoint: GeoPoint(lat: -30, lng: 130),
        waterType: Water.nonDrinking,
      );

      setUpAll(() async {
        await dataSource.insertWaterSources([sample1, sample2, sample3]);
      });

      tearDownAll(clearTestDb(db));

      test("get no item", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking],
          bounds: (
            tl: GeoPoint(lat: 10, lng: -10),
            br: GeoPoint(lat: 20, lng: -20),
          ),
        );

        final res = await dataSource.get(filter);
        expect(res.isEmpty, true);
      });

      test("get all items (all water types)", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking, Water.nonDrinking],
          bounds: (
            tl: GeoPoint(lat: 90, lng: -180),
            br: GeoPoint(lat: -90, lng: 180),
          ),
        );

        final res = await dataSource.get(filter);
        expect(res, [sample1, sample2, sample3]);
      });

      test("get all items (empty water types)", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [],
          bounds: (
            tl: GeoPoint(lat: 90, lng: -180),
            br: GeoPoint(lat: -90, lng: 180),
          ),
        );

        final res = await dataSource.get(filter);
        expect(res, [sample1, sample2, sample3]);
      });

      test("get all drinking water sources", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking],
          bounds: (
            tl: GeoPoint(lat: 90, lng: -180),
            br: GeoPoint(lat: -90, lng: 180),
          ),
        );

        final res = await dataSource.get(filter);
        expect(res, [sample1, sample2]);
      });

      test("get all non drinking water sources", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.nonDrinking],
          bounds: (
            tl: GeoPoint(lat: 90, lng: -180),
            br: GeoPoint(lat: -90, lng: 180),
          ),
        );

        final res = await dataSource.get(filter);
        expect(res, [sample3]);
      });

      test("get drinking water sources in scoped bounds", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking],
          bounds: (
            tl: GeoPoint(lat: 40, lng: -140),
            br: GeoPoint(lat: -10, lng: -10),
          ),
        );

        final res = await dataSource.get(filter);
        expect(res, [sample1]);
      });

      test("get nonnn drinking water sources in scoped bounds", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.nonDrinking],
          bounds: (
            tl: GeoPoint(lat: -20, lng: 120),
            br: GeoPoint(lat: -40, lng: 140),
          ),
        );

        final res = await dataSource.get(filter);
        expect(
          res,
          [sample3],
        );
      });
    });

    group("get wrap around", () {
      const sample1 = SQFliteWaterSourceModel(
        id: "id1",
        name: "name1",
        geoPoint: GeoPoint(lat: 30, lng: -130),
        waterType: Water.drinking,
      );

      const sample2 = SQFliteWaterSourceModel(
        id: "id2",
        name: "name2",
        geoPoint: GeoPoint(lat: 0, lng: 0),
        waterType: Water.drinking,
      );

      const sample3 = SQFliteWaterSourceModel(
        id: "id3",
        name: "name3",
        geoPoint: GeoPoint(lat: -30, lng: 130),
        waterType: Water.nonDrinking,
      );

      setUpAll(() async {
        await dataSource.insertWaterSources([sample1, sample2, sample3]);
      });

      tearDownAll(clearTestDb(db));

      test("get no item", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking],
          bounds: (
            tl: GeoPoint(lat: 10, lng: 140),
            br: GeoPoint(lat: -20, lng: -140),
          ),
        );

        final res = await dataSource.getWrapAround(filter);
        expect(res.isEmpty, true);
      });

      test("get wrap around on extremities", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking, Water.nonDrinking],
          bounds: (
            tl: GeoPoint(lat: 90, lng: 180),
            br: GeoPoint(lat: -90, lng: -180)
          ),
        );

        final res = await dataSource.getWrapAround(filter);
        expect(res.isEmpty, true);
      });

      test("get wrap around all items", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking, Water.nonDrinking],
          bounds: (
            tl: GeoPoint(lat: 90, lng: 0),
            br: GeoPoint(lat: -90, lng: 0)
          ),
        );

        final res = await dataSource.getWrapAround(filter);
        expect(res, [sample1, sample2, sample3]);
      });

      test("get all items (empty water types)", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [],
          bounds: (
            tl: GeoPoint(lat: 90, lng: 0),
            br: GeoPoint(lat: -90, lng: 0)
          ),
        );

        final res = await dataSource.getWrapAround(filter);
        expect(res, [sample1, sample2, sample3]);
      });

      test("get all drinking water sources", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking],
          bounds: (
            tl: GeoPoint(lat: 90, lng: 0),
            br: GeoPoint(lat: -90, lng: 0),
          ),
        );

        final res = await dataSource.getWrapAround(filter);
        expect(res, [sample1, sample2]);
      });

      test("get all non drinking water sources", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.nonDrinking],
          bounds: (
            tl: GeoPoint(lat: 90, lng: 0),
            br: GeoPoint(lat: -90, lng: 0),
          ),
        );

        final res = await dataSource.getWrapAround(filter);
        expect(res, [sample3]);
      });

      test("get drinking water sources in scoped bounds", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking],
          bounds: (
            tl: GeoPoint(lat: 40, lng: 120),
            br: GeoPoint(lat: -40, lng: -120),
          ),
        );

        final res = await dataSource.getWrapAround(filter);
        expect(res, [sample1]);
      });

      test("get nonn drinking water sources in scoped bounds", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.nonDrinking],
          bounds: (
            tl: GeoPoint(lat: 40, lng: 120),
            br: GeoPoint(lat: -40, lng: -120),
          ),
        );

        final res = await dataSource.getWrapAround(filter);
        expect(
          res,
          [sample3],
        );
      });
    });
  });
}
