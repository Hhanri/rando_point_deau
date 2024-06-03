import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_download_and_save_use_case.dart';
import 'package:rando_point_deau/features/water/presentation/cubits/water_downloader_cubit/water_downloader_cubit.dart';

final class MockWaterDownloadAndSaveUseCase extends Mock
    implements WaterDownloadAndSaveUseCase {}

main() {
  final waterDownloadAndSaveUseCase = MockWaterDownloadAndSaveUseCase();

  group("water downloader cubit test", () {
    test("initial state", () {
      final cubit = WaterDownloaderCubit(
        waterDownloadAndSaveUseCase: waterDownloadAndSaveUseCase,
      );

      expect(cubit.state, WaterDownloaderInitial());
    });

    group("download test", () {
      test("download and save error", () async {
        final cubit = WaterDownloaderCubit(
          waterDownloadAndSaveUseCase: waterDownloadAndSaveUseCase,
        );

        when(
          () => waterDownloadAndSaveUseCase.call(
            progressCallback: any(named: "progressCallback"),
          ),
        ).thenAnswer(
          (_) => TaskEither.left(
            const Failure(message: "download and save error"),
          ),
        );

        await cubit.download();

        expect(
          cubit.state,
          WaterDownloaderError("download and save error"),
        );
      });

      test("download and save success", () async {
        final cubit = WaterDownloaderCubit(
          waterDownloadAndSaveUseCase: waterDownloadAndSaveUseCase,
        );

        when(
          () => waterDownloadAndSaveUseCase.call(
            progressCallback: any(named: "progressCallback"),
          ),
        ).thenAnswer(
          (_) => TaskEither.right(
            const Success(value: Empty()),
          ),
        );

        await cubit.download();

        expect(
          cubit.state,
          WaterDownloaderSuccess(),
        );
      });
    });
  });
}
