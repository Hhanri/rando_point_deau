import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando_point_deau/core/wrappers/cached_stream.dart';
import 'package:rando_point_deau/features/map/presentation/cubits/map_filters_cubit/map_filters_cubit.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_filter_entity.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_search_use_case.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final WaterSearchUseCase waterSearchUseCase;
  final CachedStream<MapFiltersState> filtersStateStream;

  MapCubit({
    required this.waterSearchUseCase,
    required this.filtersStateStream,
  }) : super(MapInitial());

  late final StreamSubscription<MapFiltersState> sub;

  void init() {
    sub = filtersStateStream.asBroadcastStream().listen((event) async {
      final state = this.state;
      if (state is MapSuccess) await search(state.bounds);
    });
  }

  Future<void> search(GeoBounds bounds) async {
    emit(MapLoading());
    final res = await waterSearchUseCase
        .call(
          WaterSourceFilterEntity(
            waterTypes: filtersStateStream.mostRecent.filters,
            bounds: bounds,
          ),
        )
        .run();

    res.fold(
      (failure) => emit(MapError(failure.message)),
      (success) => emit(
        MapSuccess(bounds: bounds, waterSources: success.value),
      ),
    );
  }

  @override
  Future<void> close() async {
    sub.cancel();
    return super.close();
  }
}
