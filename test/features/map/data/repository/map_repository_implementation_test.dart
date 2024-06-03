import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/features/map/data/data_sources/map_data_source_interface.dart';
import 'package:rando_point_deau/features/map/data/repository/map_repository_implementation.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

final class _MockMapDataSource extends Mock implements MapDataSourceInterface {}

void main() {
  final dataSource = _MockMapDataSource();
  final repo = MapRepositoryImplementation(dataSource);

  group("map repository implementation test", () {
    group("get filters test", () {
      test("failure", () async {
        when(dataSource.getFilters).thenThrow("get filters error");

        final res = await repo.getFilters().run();

        expect(res, const Left(Failure(message: "get filters error")));
      });

      test("success", () async {
        when(
          dataSource.getFilters,
        ).thenAnswer(
          (_) async => Water.values,
        );

        final res = await repo.getFilters().run();

        expect(res, const Right(Success(value: Water.values)));
      });
    });

    group("set filters test", () {
      test("failure", () async {
        when(
          () => dataSource.setFilters([Water.nonDrinkable]),
        ).thenThrow("set filters error");

        final res = await repo.setFilters([Water.nonDrinkable]).run();

        expect(res, const Left(Failure(message: "set filters error")));
      });

      test("success", () async {
        when(
          () => dataSource.setFilters([Water.nonDrinkable]),
        ).thenAnswer((_) async => [Water.nonDrinkable]);

        final res = await repo.setFilters([Water.nonDrinkable]).run();

        expect(res, const Right(Success(value: [Water.nonDrinkable])));
      });
    });
  });
}
