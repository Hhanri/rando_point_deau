part of 'map_filters_cubit.dart';

final class MapFiltersState extends Equatable {
  final List<Water> filters;

  const MapFiltersState(this.filters);

  factory MapFiltersState.initial() {
    return MapFiltersState(List.empty(growable: true));
  }

  @override
  List<Object?> get props => [
        filters,
      ];
}
