import 'package:flutter_test/flutter_test.dart';
import 'package:rando_point_deau/core/value_objects/geopoint.dart';
import 'package:rando_point_deau/features/water/data/models/sqflite_water_source_model.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

void main() {

  group("sqflite water source model test", () {

    final json = {
      "id": "someId",
      "name": "someName",
      "lat": 2,
      "lng": 3,
      "type": "drinking",
    };

    const model = SQFliteWaterSourceModel(
      id: "someId",
      name: "someName",
      geoPoint: GeoPoint(lat: 2, lng: 3),
      waterType: Water.drinking,
    );

    test('from json', () {
      expect(
        SQFliteWaterSourceModel.fromJson(json),
        model
      );
    });

    test('to json', () {
      expect(
        model.toJson(),
        json
      );
    });

  });

}