part of 'map_cubit.dart';

sealed class MapState extends Equatable {
  const MapState();
}

final class MapInitial extends MapState {
  @override
  List<Object> get props => [];
}

final class MapLoading extends MapState {
  @override
  List<Object> get props => [];
}

final class MapSuccess extends MapState {
  final GeoBounds bounds;
  final List<WaterSourceEntity> waterSources;

  const MapSuccess({
    required this.bounds,
    required this.waterSources,
  });

  @override
  List<Object> get props => [
        bounds,
        waterSources,
      ];
}

final class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object> get props => [
        message,
      ];
}
