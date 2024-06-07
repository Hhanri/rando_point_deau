import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando_point_deau/config/setup_container.dart';
import 'package:rando_point_deau/features/map/presentation/cubits/map_cubit/map_cubit.dart';
import 'package:rando_point_deau/features/map/presentation/cubits/map_filters_cubit/map_filters_cubit.dart';
import 'package:rando_point_deau/features/map/presentation/pages/map_page.dart';
import 'package:rando_point_deau/features/map/presentation/widgets/map_widget/map_widget_interface.dart';

class MapPageWrapper extends StatelessWidget {
  const MapPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl.get<MapFiltersCubit>(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => sl.get<MapCubit>(
            param1: context.read<MapFiltersCubit>(),
          ),
          lazy: false,
        )
      ],
      child: MapPage(
        mapBuilder: (cubit, sources) {
          return sl.get<MapWidgetInterface>(
            param1: sources,
            param2: cubit,
          );
        },
      ),
    );
  }
}
