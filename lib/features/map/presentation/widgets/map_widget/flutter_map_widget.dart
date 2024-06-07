import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:rando_point_deau/core/theme/padding.dart';
import 'package:rando_point_deau/core/utils/list.dart';
import 'package:rando_point_deau/core/value_objects/geopoint.dart';
import 'package:rando_point_deau/features/map/presentation/cubits/map_cubit/map_cubit.dart';
import 'package:rando_point_deau/features/map/presentation/widgets/map_widget/map_widget_interface.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_filter_entity.dart';

class FlutterMapWidget extends StatefulWidget implements MapWidgetInterface {
  final MapCubit cubit;
  final TileProvider tileProvider;
  final List<WaterSourceEntity> waterSources;

  const FlutterMapWidget({
    super.key,
    required this.cubit,
    required this.tileProvider,
    required this.waterSources,
  });

  @override
  State<FlutterMapWidget> createState() => _FlutterMapWidgetState();
}

class _FlutterMapWidgetState extends State<FlutterMapWidget>
    implements MapWidgetStateInterface {
  final mapController = MapController();
  late final StreamSubscription<MapEvent> subscription;
  late final StreamController<double?> _alignPositionStreamController;

  bool _isLastMoveManual = false;

  @override
  void initState() {
    super.initState();
    _alignPositionStreamController = StreamController<double?>();
    subscription = mapController.mapEventStream.listen((event) {
      final wentToLocation = event is MapEventWithMove &&
          event.source == MapEventSource.mapController &&
          event.camera.zoom == defaultZoom &&
          _isLastMoveManual == true;

      if (event is MapEventFlingAnimationEnd ||
          event is MapEventMoveEnd ||
          wentToLocation) {
        loadMarkers(mapCameraToGeoBounds(event.camera));
      }

      _isLastMoveManual = event.source != MapEventSource.mapController;
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        keepAlive: true,
        onMapReady: () =>
            loadMarkers(mapCameraToGeoBounds(mapController.camera)),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          tileProvider: widget.tileProvider,
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            size: const Size(40, 40),
            alignment: Alignment.center,
            forceIntegerZoomLevel: true,
            maxZoom: 18,
            markers: widget.waterSources.mapList(
              (e) => Marker(
                point: LatLng(e.geoPoint.lat, e.geoPoint.lng),
                child: const FlutterLogo(),
              ),
            ),
            builder: (context, markers) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    markers.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        CurrentLocationLayer(
          alignPositionStream: _alignPositionStreamController.stream,
        ),
        userLocationFAB(),
      ],
    );
  }

  @override
  double get defaultZoom => 18;

  @override
  void loadMarkers(GeoBounds geoBounds) {
    widget.cubit.search(geoBounds);
  }

  @override
  void moveToUserPosition() {
    _alignPositionStreamController.add(defaultZoom);
  }

  GeoBounds mapCameraToGeoBounds(MapCamera camera) {
    final tl = GeoPoint(
      lat: camera.visibleBounds.northWest.latitude,
      lng: camera.visibleBounds.northWest.longitude,
    );
    final br = GeoPoint(
      lat: camera.visibleBounds.southEast.latitude,
      lng: camera.visibleBounds.southEast.longitude,
    );
    return (tl: tl, br: br);
  }

  Widget userLocationFAB() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: AppPadding.all24,
        child: FloatingActionButton(
          onPressed: moveToUserPosition,
          child: const Icon(
            Icons.my_location,
          ),
        ),
      ),
    );
  }
}
