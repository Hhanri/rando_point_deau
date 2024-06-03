import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/core/value_objects/geopoint.dart';
import 'package:rando_point_deau/core/wrappers/cached_stream.dart';
import 'package:rando_point_deau/features/map/presentation/cubits/map_cubit/map_cubit.dart';
import 'package:rando_point_deau/features/map/presentation/cubits/map_filters_cubit/map_filters_cubit.dart';
import 'package:rando_point_deau/features/water/data/models/owater_water_source_model.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_filter_entity.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_search_use_case.dart';

final class _MockWaterSearchUseCase extends Mock
    implements WaterSearchUseCase {}

void main() {
  final waterSearchUseCase = _MockWaterSearchUseCase();

  (MapCubit, StreamController<MapFiltersState>) setupCubit() {
    final streamController = StreamController<MapFiltersState>();
    final cubit = MapCubit(
      waterSearchUseCase: waterSearchUseCase,
      filtersStateStream: CachedStream(streamController.stream),
    );
    return (cubit, streamController);
  }

  group("map cubit test", () {
    test("initial state", () {
      final (cubit, _) = setupCubit();
      expect(cubit.state, MapInitial());
    });

    const GeoBounds boundsSample = (
      tl: GeoPoint(lat: 10, lng: 10),
      br: GeoPoint(lat: -10, lng: 10),
    );

    group("search test", () {
      test("search error", () async {
        final (cubit, streamController) = setupCubit();
        cubit.init();

        streamController.add(
          const MapFiltersState([Water.drinking]),
        );
        await Future.delayed(const Duration(microseconds: 1));

        when(
          () => waterSearchUseCase.call(
            const WaterSourceFilterEntity(
              waterTypes: [Water.drinking],
              bounds: boundsSample,
            ),
          ),
        ).thenAnswer(
          (_) => TaskEither.left(const Failure(message: "search error")),
        );

        expect(
          cubit.stream,
          emitsInOrder([
            MapLoading(),
            const MapError("search error"),
          ]),
        );
        await cubit.search(boundsSample);
      });

      test("search success", () async {
        final (cubit, streamController) = setupCubit();
        cubit.init();

        streamController.add(
          const MapFiltersState([Water.drinking]),
        );
        await Future.delayed(const Duration(microseconds: 1));

        when(
          () => waterSearchUseCase.call(
            const WaterSourceFilterEntity(
              waterTypes: [Water.drinking],
              bounds: boundsSample,
            ),
          ),
        ).thenAnswer(
          (_) => TaskEither.right(
            const Success(value: [
              OwaterWaterSourceModel(
                id: "id",
                name: "name",
                geoPoint: GeoPoint(lat: 4, lng: 5),
                waterType: Water.drinking,
              )
            ]),
          ),
        );

        expect(
          cubit.stream,
          emitsInOrder([
            MapLoading(),
            const MapSuccess(
              bounds: boundsSample,
              waterSources: [
                OwaterWaterSourceModel(
                  id: "id",
                  name: "name",
                  geoPoint: GeoPoint(lat: 4, lng: 5),
                  waterType: Water.drinking,
                )
              ],
            ),
          ]),
        );
        await cubit.search(boundsSample);
      });
    });

    group("map filter stream listening test", () {
      setUp(() {
        reset(waterSearchUseCase);
      });

      test("when map is not loaded", () async {
        final (cubit, streamController) = setupCubit();
        cubit.init();

        streamController.add(
          const MapFiltersState([Water.drinking]),
        );
        await Future.delayed(const Duration(microseconds: 1));

        when(
          () => waterSearchUseCase.call(
            const WaterSourceFilterEntity(
              waterTypes: [Water.drinking],
              bounds: boundsSample,
            ),
          ),
        ).thenAnswer(
          (_) => TaskEither.right(
            const Success(value: [
              OwaterWaterSourceModel(
                id: "id",
                name: "name",
                geoPoint: GeoPoint(lat: 4, lng: 5),
                waterType: Water.drinking,
              )
            ]),
          ),
        );

        verifyNever(
          () => waterSearchUseCase.call(
            const WaterSourceFilterEntity(
              waterTypes: [Water.drinking],
              bounds: boundsSample,
            ),
          ),
        );
        expect(cubit.state, MapInitial());
      });

      setUp(() {
        reset(waterSearchUseCase);
      });

      test("when map is loaded", () async {
        final (cubit, streamController) = setupCubit();
        cubit.init();

        streamController.add(
          const MapFiltersState([Water.drinking]),
        );
        await Future.delayed(const Duration(microseconds: 1));

        when(
          () => waterSearchUseCase.call(
            const WaterSourceFilterEntity(
              waterTypes: [Water.drinking],
              bounds: boundsSample,
            ),
          ),
        ).thenAnswer(
          (_) => TaskEither.right(
            const Success(value: [
              OwaterWaterSourceModel(
                id: "id",
                name: "name",
                geoPoint: GeoPoint(lat: 4, lng: 5),
                waterType: Water.drinking,
              )
            ]),
          ),
        );

        when(
          () => waterSearchUseCase.call(
            const WaterSourceFilterEntity(
              waterTypes: [Water.drinking, Water.nonDrinkable],
              bounds: boundsSample,
            ),
          ),
        ).thenAnswer(
          (_) => TaskEither.right(
            const Success(value: [
              OwaterWaterSourceModel(
                id: "id",
                name: "name",
                geoPoint: GeoPoint(lat: 4, lng: 5),
                waterType: Water.drinking,
              ),
              OwaterWaterSourceModel(
                id: "id2",
                name: "name2",
                geoPoint: GeoPoint(lat: 4, lng: 5),
                waterType: Water.nonDrinkable,
              )
            ]),
          ),
        );

        // first loading from manual input
        expect(
          cubit.stream,
          emitsInOrder([
            MapLoading(),
            const MapSuccess(
              bounds: boundsSample,
              waterSources: [
                OwaterWaterSourceModel(
                  id: "id",
                  name: "name",
                  geoPoint: GeoPoint(lat: 4, lng: 5),
                  waterType: Water.drinking,
                ),
              ],
            ),
          ]),
        );
        await cubit.search(boundsSample);

        expect(
          cubit.stream,
          emitsInOrder([
            MapLoading(),
            const MapSuccess(
              bounds: boundsSample,
              waterSources: [
                OwaterWaterSourceModel(
                  id: "id",
                  name: "name",
                  geoPoint: GeoPoint(lat: 4, lng: 5),
                  waterType: Water.drinking,
                ),
                OwaterWaterSourceModel(
                  id: "id2",
                  name: "name2",
                  geoPoint: GeoPoint(lat: 4, lng: 5),
                  waterType: Water.nonDrinkable,
                )
              ],
            ),
          ]),
        );

        // second loading through stream change
        streamController.add(
          const MapFiltersState([Water.drinking, Water.nonDrinkable]),
        );
        await Future.delayed(const Duration(microseconds: 1));

        verify(
          () => waterSearchUseCase.call(
            const WaterSourceFilterEntity(
              waterTypes: [Water.drinking],
              bounds: boundsSample,
            ),
          ),
        ).called(1);

        verify(
          () => waterSearchUseCase.call(
            const WaterSourceFilterEntity(
              waterTypes: [Water.drinking, Water.nonDrinkable],
              bounds: boundsSample,
            ),
          ),
        ).called(1);
      });
    });
  });
}
