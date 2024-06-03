import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando_point_deau/features/map/domain/use_cases/map_get_filters_use_case.dart';
import 'package:rando_point_deau/features/map/domain/use_cases/map_set_filters_use_case.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

part 'map_filters_state.dart';

class MapFiltersCubit extends Cubit<MapFiltersState> {
  final MapGetFiltersUseCase getFiltersUseCase;
  final MapSetFiltersUseCase setFiltersUseCase;

  MapFiltersCubit({
    required this.getFiltersUseCase,
    required this.setFiltersUseCase,
  }) : super(MapFiltersState.initial());

  Future<void> init() async {
    final res = await getFiltersUseCase.call().run();
    res.fold(
      (failure) => emit(MapFiltersState.initial()),
      (success) => emit(MapFiltersState(success.value)),
    );
  }

  Future<void> setFilter(Water waterType) async {
    state.filters.contains(waterType)
        ? state.filters.remove(waterType)
        : state.filters.add(waterType);

    emit(MapFiltersState([...state.filters]));

    await setFiltersUseCase.call(state.filters).run();
  }
}
