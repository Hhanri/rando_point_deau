import 'package:rando_point_deau/core/value_objects/geopoint.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

final class OwaterWaterSourceModel extends WaterSourceEntity {
  const OwaterWaterSourceModel({
    required super.id,
    required super.name,
    required super.geoPoint,
    required super.waterType,
  });

  factory OwaterWaterSourceModel.fromJson(Map<String, dynamic> json) {
    return OwaterWaterSourceModel(
      id: json['id'],
      name: json['name'],
      geoPoint: GeoPoint(
        lat: (json["geo"]["latitude"] as num).toDouble(),
        lng: (json["geo"]["longitude"] as num).toDouble(),
      ),
      waterType: owaterWaterTypeParser(
        (json["categories"] as List).firstOrNull ?? "",
      ),
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

WaterEnumParser owaterWaterTypeParser = (String value) {
  return switch (value) {
    "Drinking water" => Water.drinking,
    "Non-drinkable water" => Water.nonDrinkable,
    _ => Water.nonDrinkable,
  };
};
