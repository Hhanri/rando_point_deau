import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:rando_point_deau/core/db/sqflite_setup.dart';
import 'package:rando_point_deau/core/wrappers/cached_stream.dart';
import 'package:rando_point_deau/features/map/data/data_sources/map_data_source_interface.dart';
import 'package:rando_point_deau/features/map/data/data_sources/map_local_data_source.dart';
import 'package:rando_point_deau/features/map/data/repository/map_repository_implementation.dart';
import 'package:rando_point_deau/features/map/domain/repository/map_repository_interface.dart';
import 'package:rando_point_deau/features/map/domain/use_cases/map_get_filters_use_case.dart';
import 'package:rando_point_deau/features/map/domain/use_cases/map_set_filters_use_case.dart';
import 'package:rando_point_deau/features/map/presentation/cubits/map_cubit/map_cubit.dart';
import 'package:rando_point_deau/features/map/presentation/cubits/map_filters_cubit/map_filters_cubit.dart';
import 'package:rando_point_deau/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:rando_point_deau/features/water/data/data_sources/owater_water_data_source.dart';
import 'package:rando_point_deau/features/water/data/data_sources/sqfite_water_data_source.dart';
import 'package:rando_point_deau/features/water/data/data_sources/water_local_data_source_interface.dart';
import 'package:rando_point_deau/features/water/data/data_sources/water_remote_data_source_interface.dart';
import 'package:rando_point_deau/features/water/data/repository/water_repository_implementation.dart';
import 'package:rando_point_deau/features/water/domain/repository/water_repository_interface.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_download_and_save_use_case.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_has_local_data_use_case.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_search_use_case.dart';
import 'package:rando_point_deau/features/water/presentation/cubits/water_downloader_cubit/water_downloader_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

typedef ContainerSetupFunc = Future<void> Function(GetIt sl);

Future<void> setupSL(
    [List<ContainerSetupFunc> setupFunctions = const []]) async {
  final httpClient = http.Client();

  final db = await SQFliteConfig.openDatabase("rando_point_deau.db");

  final prefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton<WaterRemoteDataSourceInterface>(
    () => OwaterWaterDataSource(httpClient),
  );
  sl.registerLazySingleton<WaterLocalDataSourceInterface>(
    () => SQFliteWaterDataSource(db),
  );
  sl.registerLazySingleton<WaterRepositoryInterface>(
    () => WaterRepositoryImplementation(
      localDataSource: sl.get<WaterLocalDataSourceInterface>(),
      remoteDataSource: sl.get<WaterRemoteDataSourceInterface>(),
    ),
  );
  sl.registerLazySingleton<WaterDownloadAndSaveUseCase>(
    () => WaterDownloadAndSaveUseCase(
      sl.get<WaterRepositoryInterface>(),
    ),
  );
  sl.registerLazySingleton<WaterHasLocalDataUseCase>(
    () => WaterHasLocalDataUseCase(
      sl.get<WaterRepositoryInterface>(),
    ),
  );
  sl.registerLazySingleton<WaterSearchUseCase>(
    () => WaterSearchUseCase(
      sl.get<WaterRepositoryInterface>(),
    ),
  );

  sl.registerFactory<WaterDownloaderCubit>(
    () => WaterDownloaderCubit(
      waterDownloadAndSaveUseCase: sl.get<WaterDownloadAndSaveUseCase>(),
    ),
  );

  sl.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(
      waterHasLocalDataUseCase: sl.get<WaterHasLocalDataUseCase>(),
    )..init(),
  );

  sl.registerLazySingleton<MapDataSourceInterface>(
    () => MapLocalDataSource(prefs),
  );
  sl.registerLazySingleton<MapRepositoryInterface>(
    () => MapRepositoryImplementation(
      sl.get<MapDataSourceInterface>(),
    ),
  );
  sl.registerLazySingleton<MapSetFiltersUseCase>(
    () => MapSetFiltersUseCase(
      sl.get<MapRepositoryInterface>(),
    ),
  );
  sl.registerLazySingleton<MapGetFiltersUseCase>(
    () => MapGetFiltersUseCase(
      sl.get<MapRepositoryInterface>(),
    ),
  );

  sl.registerFactory<MapFiltersCubit>(
    () => MapFiltersCubit(
      getFiltersUseCase: sl.get<MapGetFiltersUseCase>(),
      setFiltersUseCase: sl.get<MapSetFiltersUseCase>(),
    )..init(),
  );
  sl.registerFactoryParam<MapCubit, MapFiltersCubit, void>(
    (p1, _) => MapCubit(
      waterSearchUseCase: sl.get<WaterSearchUseCase>(),
      filtersStateStream: CachedStream(
        p1.stream,
        defaultValue: MapFiltersState.initial(),
      ),
    )..init(),
  );

  for (final func in setupFunctions) {
    await func(sl);
  }
}
