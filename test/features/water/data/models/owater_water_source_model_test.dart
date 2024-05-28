import 'package:flutter_test/flutter_test.dart';
import 'package:rando_point_deau/core/value_objects/geopoint.dart';
import 'package:rando_point_deau/features/water/data/models/owater_water_source_model.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

void main() {

  group("owater water source model test", () {

    final json = {
      "id": "mM",
      "name": "Fountain",
      "geo": {
        "latitude": 48.88482,
        "longitude": 2.29816
      },
      "categories": [
        "Drinking water"
      ],
    };

    const model = OwaterWaterSourceModel(
      id: "mM",
      name: "Fountain",
      geoPoint: GeoPoint(lat: 48.88482, lng: 2.29816),
      waterType: Water.drinking,
    );

    test('from json', () {
      expect(
        OwaterWaterSourceModel.fromJson(json),
        model
      );
    });

    test('to json', () {
      expect(
        model.toJson(),
        {
          "id": "mM",
          "name": "Fountain",
          "lat": 48.88482,
          "lng": 2.29816,
          "type": "drinking",
        }
      );
    });

  });

}