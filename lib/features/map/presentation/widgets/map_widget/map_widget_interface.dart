import 'package:flutter/material.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_filter_entity.dart';

abstract interface class MapWidgetInterface implements StatefulWidget {}

abstract interface class MapWidgetStateInterface {
  final double defaultZoom = 18;

  void moveToUserPosition();

  void loadMarkers(GeoBounds geoBounds);
}
