import 'package:flutter_test/flutter_test.dart';
import 'package:rando_point_deau/core/value_objects/geopoint.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_filter_entity.dart';

void main() {
  group("geo bounds test", () {
    group("is cross anti meridian", () {
      test("false", () {
        const GeoBounds bounds = (
          tl: GeoPoint(lat: 10, lng: 110),
          br: GeoPoint(lat: -10, lng: 140),
        );

        expect(bounds.isCrossAntiMeridian, false);
      });

      test("true", () {
        const GeoBounds bounds = (
          tl: GeoPoint(lat: 10, lng: 170),
          br: GeoPoint(lat: -10, lng: -170),
        );

        expect(bounds.isCrossAntiMeridian, true);
      });
    });
  });
}
