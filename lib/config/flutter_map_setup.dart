import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:rando_point_deau/config/setup_container.dart';
import 'package:rando_point_deau/features/map/presentation/cubits/map_cubit/map_cubit.dart';
import 'package:rando_point_deau/features/map/presentation/widgets/map_widget/flutter_map_widget.dart';
import 'package:rando_point_deau/features/map/presentation/widgets/map_widget/map_widget_interface.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';

ContainerSetupFunc flutterMapSetupContainer = (sl) async {
  sl.registerSingleton<TileProvider>(await _getFlutterMapTileProvider());

  sl.registerFactoryParam<MapWidgetInterface, List<WaterSourceEntity>,
      MapCubit>(
    (param1, param2) => FlutterMapWidget(
      cubit: param2,
      tileProvider: sl.get<TileProvider>(),
      waterSources: param1,
    ),
  );
};

Future<TileProvider> _getFlutterMapTileProvider() async {
  await FMTCObjectBoxBackend().initialise();
  const fmtcStore = FMTCStore('mapStore');
  await fmtcStore.manage.create();
  return fmtcStore.getTileProvider();
}
