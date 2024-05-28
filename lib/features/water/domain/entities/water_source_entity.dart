import 'package:equatable/equatable.dart';
import 'package:rando_point_deau/core/value_objects/geopoint.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

abstract base class WaterSourceEntity extends Equatable {

  final String id;
  final String name;
  final GeoPoint geoPoint;
  final Water waterType;

  const WaterSourceEntity({
    required this.id,
    required this.name,
    required this.geoPoint,
    required this.waterType,
  });

  Map<String, dynamic> toJson();

}