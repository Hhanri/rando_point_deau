import 'package:flutter_test/flutter_test.dart';
import 'package:rando_point_deau/core/value_objects/geopoint.dart';
import 'package:rando_point_deau/features/water/data/data_sources/owater_water_data_source.dart';
import 'package:rando_point_deau/features/water/data/models/owater_water_source_model.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';

import '../../../../test_setup/mock_http.dart';

void main() {
  group("owater water data source test", () {
    const body = '''{
      "licence": "https://opendatacommons.org/licenses/odbl/summary/",
      "ontology":"gogofull",
      "data": [
        {
          "id": "mM",
          "name": "Fountain",
          "geo": {
            "latitude": 48.88482,
            "longitude": 2.29816
          },
          
          "categories": [
            "Drinking water"
          ]
        },
        {
          "id": "mR",
          "name": "Fountain Drinking water",
          "geo": {
            "latitude": 45.99645,
            "longitude": 6.24928
          },
          "categories": [
            "Drinking water"
          ]
        },
        {
          "id": "mS",
          "name": "WC publiques",
          "geo": {
            "latitude": 44.50427,
            "longitude": 1.13662
          },
          "categories": [
            "Drinking water"
          ]
        },
        {
          "id": "mT",
          "name": "WC publiques",
          "geo": {
            "latitude": 44.50427,
            "longitude": 1.13662
          },
          "categories": [
            "Drinking water"
          ]
        },
        {
          "id": "mU",
          "name": "Drinking water - place paul doumer, nantes",
          "geo": {
            "latitude": 47.22183,
            "longitude": -1.57879
          },
          "categories": [
            "Drinking water"
          ]
        },
        {
          "id": "mV",
          "name": "Fountain",
          "geo": {
            "latitude": 43.95605,
            "longitude": 5.02951
          },
          "categories": [
            "Non-drinkable water"
          ]
        },
        {
          "id": "mW",
          "name": "Fountain",
          "geo": {
            "latitude": 43.95662,
            "longitude": 5.02932
          },
          "categories": [
            "Non-drinkable water"
          ]
        },
        {
          "id": "mX",
          "name": "Fountain",
          "geo": {
            "latitude": 43.95656,
            "longitude": 5.02796
          },
          "categories": [
            "Non-drinkable water"
          ]
        },
        {
          "id": "mY",
          "name": "Fountain",
          "geo": {
            "latitude": 43.95577,
            "longitude": 5.02861
          },
          "categories": [
            "Non-drinkable water"
          ]
        },
        {
          "id": "mZ",
          "name": "Fountain",
          "geo": {
            "latitude": 43.95743,
            "longitude": 5.02968
          },
          "categories": [
            "Non-drinkable water"
          ]
        }
      ]
    }''';

    final client = mockStreamedResponseClient(body);

    final dataSource = OwaterWaterDataSource(client);

    test('get all sources', () async {
      final res = await dataSource.getAllWaterSources();

      const expected = [
        OwaterWaterSourceModel(
          id: "mM",
          name: "Fountain",
          geoPoint: GeoPoint(lat: 48.88482, lng: 2.29816),
          waterType: Water.drinking,
        ),
        OwaterWaterSourceModel(
          id: "mR",
          name: "Fountain Drinking water",
          geoPoint: GeoPoint(lat: 45.99645, lng: 6.24928),
          waterType: Water.drinking,
        ),
        OwaterWaterSourceModel(
          id: "mS",
          name: "WC publiques",
          geoPoint: GeoPoint(lat: 44.50427, lng: 1.13662),
          waterType: Water.drinking,
        ),
        OwaterWaterSourceModel(
          id: "mT",
          name: "WC publiques",
          geoPoint: GeoPoint(lat: 44.50427, lng: 1.13662),
          waterType: Water.drinking,
        ),
        OwaterWaterSourceModel(
          id: "mU",
          name: "Drinking water - place paul doumer, nantes",
          geoPoint: GeoPoint(lat: 47.22183, lng: -1.57879),
          waterType: Water.drinking,
        ),
        OwaterWaterSourceModel(
          id: "mV",
          name: "Fountain",
          geoPoint: GeoPoint(lat: 43.95605, lng: 5.02951),
          waterType: Water.nonDrinkable,
        ),
        OwaterWaterSourceModel(
          id: "mW",
          name: "Fountain",
          geoPoint: GeoPoint(lat: 43.95662, lng: 5.02932),
          waterType: Water.nonDrinkable,
        ),
        OwaterWaterSourceModel(
          id: "mX",
          name: "Fountain",
          geoPoint: GeoPoint(lat: 43.95656, lng: 5.02796),
          waterType: Water.nonDrinkable,
        ),
        OwaterWaterSourceModel(
          id: "mY",
          name: "Fountain",
          geoPoint: GeoPoint(lat: 43.95577, lng: 5.02861),
          waterType: Water.nonDrinkable,
        ),
        OwaterWaterSourceModel(
          id: "mZ",
          name: "Fountain",
          geoPoint: GeoPoint(lat: 43.95743, lng: 5.02968),
          waterType: Water.nonDrinkable,
        ),
      ];

      expect(res, expected);
    });
  });
}
