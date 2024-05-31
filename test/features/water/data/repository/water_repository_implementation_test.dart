import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/core/value_objects/geopoint.dart';
import 'package:rando_point_deau/features/water/data/data_sources/water_local_data_source_interface.dart';
import 'package:rando_point_deau/features/water/data/data_sources/water_remote_data_source_interface.dart';
import 'package:rando_point_deau/features/water/data/models/sqflite_water_source_model.dart';
import 'package:rando_point_deau/features/water/data/repository/water_repository_implementation.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_filter_entity.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

final class _MockWaterLocalDataSource extends Mock
    implements WaterLocalDataSourceInterface {}

final class _MockWaterRemoteDataSource extends Mock
    implements WaterRemoteDataSourceInterface {}

void main() {
  final localDataSource = _MockWaterLocalDataSource();
  final remoteDataSource = _MockWaterRemoteDataSource();

  final repo = WaterRepositoryImplementation(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );

  group("water repository implementation test", () {
    setUpAll(() {
      reset(localDataSource);
      reset(remoteDataSource);
    });

    group("search test", () {
      setUpAll(() {
        reset(localDataSource);
        reset(remoteDataSource);
      });

      test("cross anti meridian success", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking],
          bounds: (
            tl: GeoPoint(lat: 10, lng: 170),
            br: GeoPoint(lat: -10, lng: -170),
          ),
        );
        const waterSource = SQFliteWaterSourceModel(
          id: "id",
          name: "name",
          geoPoint: GeoPoint(lat: 180, lng: 9),
          waterType: Water.drinking,
        );

        when(
          () => localDataSource.getWrapAround(filter),
        ).thenAnswer(
          (_) async => const [waterSource],
        );

        final res = await repo.search(filter).run();

        expect(
          res,
          const Right<Failure, Success<List<WaterSourceEntity>>>(
            Success(value: [waterSource]),
          ),
        );

        verify(() => localDataSource.getWrapAround(filter)).called(1);
        verifyNever(() => localDataSource.get(filter));
      });

      test("cross anti meridian failure", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking],
          bounds: (
            tl: GeoPoint(lat: 10, lng: 170),
            br: GeoPoint(lat: -10, lng: -170),
          ),
        );

        when(
          () => localDataSource.getWrapAround(filter),
        ).thenThrow("get wrap around error");

        final res = await repo.search(filter).run();

        expect(
          res,
          const Left<Failure, Success<List<WaterSourceEntity>>>(
            Failure(message: "get wrap around error"),
          ),
        );

        verify(() => localDataSource.getWrapAround(filter)).called(1);
        verifyNever(() => localDataSource.get(filter));
      });

      test("non cross anti meridian success", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking],
          bounds: (
            tl: GeoPoint(lat: 10, lng: -10),
            br: GeoPoint(lat: -20, lng: 20),
          ),
        );
        const waterSource = SQFliteWaterSourceModel(
          id: "id",
          name: "name",
          geoPoint: GeoPoint(lat: 0, lng: 0),
          waterType: Water.drinking,
        );

        when(
          () => localDataSource.get(filter),
        ).thenAnswer(
          (_) async => const [waterSource],
        );

        final res = await repo.search(filter).run();

        expect(
          res,
          const Right<Failure, Success<List<WaterSourceEntity>>>(
            Success(value: [waterSource]),
          ),
        );

        verify(() => localDataSource.get(filter)).called(1);
        verifyNever(() => localDataSource.getWrapAround(filter));
      });

      test("non cross anti meridian failure", () async {
        const filter = WaterSourceFilterEntity(
          waterTypes: [Water.drinking],
          bounds: (
            tl: GeoPoint(lat: 10, lng: -10),
            br: GeoPoint(lat: -20, lng: 20),
          ),
        );

        when(
          () => localDataSource.get(filter),
        ).thenThrow("get wrap around error");

        final res = await repo.search(filter).run();

        expect(
          res,
          const Left<Failure, Success<List<WaterSourceEntity>>>(
            Failure(message: "get wrap around error"),
          ),
        );

        verify(() => localDataSource.get(filter)).called(1);
        verifyNever(() => localDataSource.getWrapAround(filter));
      });
    });

    group("has data test", () {
      test("true", () async {
        when(
          localDataSource.hasData,
        ).thenAnswer(
          (_) async => true,
        );

        final res = await repo.hasLocalData().run();

        expect(
          res,
          const Right<Failure, Success<bool>>(
            Success(value: true),
          ),
        );
      });

      test("false", () async {
        when(
          localDataSource.hasData,
        ).thenAnswer(
          (_) async => false,
        );

        final res = await repo.hasLocalData().run();

        expect(
          res,
          const Right<Failure, Success<bool>>(
            Success(value: false),
          ),
        );
      });

      test("failure", () async {
        when(
          localDataSource.hasData,
        ).thenThrow("has data failure");

        final res = await repo.hasLocalData().run();

        expect(
          res,
          const Left<Failure, Success<bool>>(
            Failure(message: "has data failure"),
          ),
        );
      });
    });

    group("download and save test", () {
      setUpAll(() {
        reset(localDataSource);
        reset(remoteDataSource);
      });

      final sample = [
        const SQFliteWaterSourceModel(
          id: "id1",
          name: "name1",
          geoPoint: GeoPoint(lat: 180, lng: 9),
          waterType: Water.drinking,
        ),
        const SQFliteWaterSourceModel(
          id: "id2",
          name: "name2",
          geoPoint: GeoPoint(lat: 180, lng: 9),
          waterType: Water.drinking,
        ),
      ];

      test("download failure", () async {
        when(
          remoteDataSource.getAllWaterSources,
        ).thenThrow("download error");

        final res = await repo.downloadAndSave().run();

        expect(
          res,
          const Left<Failure, EmptySuccess>(
            Failure(message: "download error"),
          ),
        );

        verify(remoteDataSource.getAllWaterSources).called(1);
        verifyNever(() => localDataSource.insertWaterSources(sample));
      });

      test("download success, insert error", () async {
        when(
          remoteDataSource.getAllWaterSources,
        ).thenAnswer((_) async => sample);

        when(
          () => localDataSource.insertWaterSources(sample),
        ).thenThrow("insert error");

        final res = await repo.downloadAndSave().run();

        expect(
          res,
          const Left<Failure, EmptySuccess>(
            Failure(message: "insert error"),
          ),
        );

        verify(remoteDataSource.getAllWaterSources).called(1);
        verify(() => localDataSource.insertWaterSources(sample)).called(1);
      });

      test("download success, insert success", () async {
        when(
          remoteDataSource.getAllWaterSources,
        ).thenAnswer((_) async => sample);

        when(
          () => localDataSource.insertWaterSources(sample),
        ).thenAnswer(
          (_) async => const Empty(),
        );

        final res = await repo.downloadAndSave().run();

        expect(
          res,
          const Right<Failure, EmptySuccess>(Success(value: Empty())),
        );

        verify(remoteDataSource.getAllWaterSources).called(1);
        verify(() => localDataSource.insertWaterSources(sample)).called(1);
      });
    });
  });
}
