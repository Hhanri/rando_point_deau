import 'package:rando_point_deau/core/value_objects/geopoint.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

final class SQFliteWaterSourceModel extends WaterSourceEntity {

  const SQFliteWaterSourceModel({
    required super.id,
    required super.name,
    required super.geoPoint,
    required super.waterType
  });

  factory SQFliteWaterSourceModel.fromJson(Map<String, dynamic> json) {
    return SQFliteWaterSourceModel(
      id: json['id'],
      name: json['name'],
      geoPoint: GeoPoint(
        lat: (json["lat"] as num).toDouble(),
        lng: (json["lng"] as num).toDouble(),
      ),
      waterType: Water.defaultParse(
        json["type"]
      )
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      ...geoPoint.toJson(),
      "type": waterType.name,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    geoPoint,
    waterType,
  ];

}
