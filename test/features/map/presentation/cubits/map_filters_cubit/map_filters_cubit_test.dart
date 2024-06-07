// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/features/map/domain/use_cases/map_get_filters_use_case.dart';
import 'package:rando_point_deau/features/map/domain/use_cases/map_set_filters_use_case.dart';
import 'package:rando_point_deau/features/map/presentation/cubits/map_filters_cubit/map_filters_cubit.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

final class _MockMapGetFiltersUseCase extends Mock
    implements MapGetFiltersUseCase {}

final class _MockMapSetFiltersUseCase extends Mock
    implements MapSetFiltersUseCase {}

void main() {
  final getFiltersUseCase = _MockMapGetFiltersUseCase();
  final setFiltersUseCase = _MockMapSetFiltersUseCase();

  group("map filters cubit test", () {
    test('initial state', () {
      final cubit = MapFiltersCubit(
        getFiltersUseCase: getFiltersUseCase,
        setFiltersUseCase: setFiltersUseCase,
      );

      expect(cubit.state, MapFiltersState.initial());
    });

    group("init test", () {
      test("get filters error", () async {
        final cubit = MapFiltersCubit(
          getFiltersUseCase: getFiltersUseCase,
          setFiltersUseCase: setFiltersUseCase,
        );

        when(
          getFiltersUseCase.call,
        ).thenAnswer(
          (_) => TaskEither.left(
            const Failure(message: "message"),
          ),
        );

        await cubit.init();

        expect(cubit.state, MapFiltersState.initial());
      });

      test("get filters success", () async {
        final cubit = MapFiltersCubit(
          getFiltersUseCase: getFiltersUseCase,
          setFiltersUseCase: setFiltersUseCase,
        );

        when(
          getFiltersUseCase.call,
        ).thenAnswer(
          (_) => TaskEither.right(
            const Success(value: [Water.drinking]),
          ),
        );

        await cubit.init();

        expect(
          cubit.state,
          const MapFiltersState([Water.drinking]),
        );
      });
    });

    group("set filters test", () {
      test("add filter when empty", () async {
        final cubit = MapFiltersCubit(
          getFiltersUseCase: getFiltersUseCase,
          setFiltersUseCase: setFiltersUseCase,
        );

        when(
          () => setFiltersUseCase.call([Water.drinking]),
        ).thenAnswer(
          (_) => TaskEither.right(
            Success(value: [Water.drinking]),
          ),
        );

        await cubit.setFilter(Water.drinking);
        expect(cubit.state, const MapFiltersState([Water.drinking]));
      });

      test("add filter", () async {
        final cubit = MapFiltersCubit(
          getFiltersUseCase: getFiltersUseCase,
          setFiltersUseCase: setFiltersUseCase,
        );
        cubit.emit(MapFiltersState([Water.nonDrinkable]));

        when(
          () => setFiltersUseCase.call([Water.nonDrinkable, Water.drinking]),
        ).thenAnswer(
          (_) => TaskEither.right(
            Success(value: [Water.nonDrinkable, Water.drinking]),
          ),
        );

        await cubit.setFilter(Water.drinking);
        expect(
          cubit.state,
          const MapFiltersState([Water.nonDrinkable, Water.drinking]),
        );

        verify(
          () => setFiltersUseCase.call([Water.nonDrinkable, Water.drinking]),
        ).called(1);
      });

      setUp(() => reset(setFiltersUseCase));
      test("remove filter", () async {
        final cubit = MapFiltersCubit(
          getFiltersUseCase: getFiltersUseCase,
          setFiltersUseCase: setFiltersUseCase,
        );
        cubit.emit(MapFiltersState([Water.nonDrinkable, Water.drinking]));

        when(
          () => setFiltersUseCase.call([Water.drinking]),
        ).thenAnswer(
          (_) => TaskEither.right(
            Success(value: [Water.drinking]),
          ),
        );

        await cubit.setFilter(Water.nonDrinkable);
        expect(
          cubit.state,
          const MapFiltersState([Water.drinking]),
        );

        verify(
          () => setFiltersUseCase.call([Water.drinking]),
        ).called(1);
      });

      test("remove unique filter", () async {
        final cubit = MapFiltersCubit(
          getFiltersUseCase: getFiltersUseCase,
          setFiltersUseCase: setFiltersUseCase,
        );
        cubit.emit(MapFiltersState([Water.drinking]));

        when(
          () => setFiltersUseCase.call([]),
        ).thenAnswer(
          (_) => TaskEither.right(
            Success(value: []),
          ),
        );

        await cubit.setFilter(Water.drinking);
        expect(
          cubit.state,
          const MapFiltersState([]),
        );

        verify(
          () => setFiltersUseCase.call([]),
        ).called(1);
      });
    });
  });
}
