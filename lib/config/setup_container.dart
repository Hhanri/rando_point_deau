import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:rando_point_deau/core/db/sqflite_setup.dart';
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
import 'package:sqflite/sqflite.dart';

final sl = GetIt.instance;

Future<void> setupSL() async {
  final httpClient = http.Client();

  final db = await databaseFactory.openDatabase(
    "rando_point_deau.db",
    options: SQFliteConfig.dbV1,
  );

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

  sl.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(
      waterHasLocalDataUseCase: sl.get<WaterHasLocalDataUseCase>(),
    )..init(),
  );
}
