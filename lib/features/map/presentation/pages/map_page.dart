import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando_point_deau/features/map/presentation/cubits/map_cubit/map_cubit.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';

class MapPage extends StatelessWidget {
  final Widget Function(MapCubit, List<WaterSourceEntity>) mapBuilder;

  const MapPage({super.key, required this.mapBuilder});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapCubit>();
    return Scaffold(
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          if (state is MapSuccess) {
            return mapBuilder(cubit, state.waterSources);
          }
          return mapBuilder(cubit, []);
        },
      ),
    );
  }
}
