import 'package:equatable/equatable.dart';
import 'package:rando_point_deau/core/value_objects/geopoint.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

typedef GeoBounds = ({GeoPoint tl, GeoPoint br});

base class WaterSourceFilterEntity extends Equatable {
  final List<Water> waterTypes;
  final GeoBounds bounds;

  const WaterSourceFilterEntity({
    required this.waterTypes,
    required this.bounds,
  });

  @override
  List<Object?> get props => [waterTypes, bounds];
}

extension GeoBoundsExtension on GeoBounds {
  bool get isCrossAntiMeridian {
    return this.br.lng < this.tl.lng;
  }
}
