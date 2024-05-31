import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_download_and_save_use_case.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_has_local_data_use_case.dart';

final class MockWaterHasLocalDataUseCase extends Mock
    implements WaterHasLocalDataUseCase {}

final class MockWaterDownloadAndSaveUseCase extends Mock
    implements WaterDownloadAndSaveUseCase {}

void main() {
  final waterHasLocalDataUseCase = MockWaterHasLocalDataUseCase();
  final waterDownloadAndSaveUseCase = MockWaterDownloadAndSaveUseCase();

  group("onboarding cubit test", () {
    test("initial state", () {
      final cubit = OnboardingCubit(
        waterHasLocalDataUseCase: waterHasLocalDataUseCase,
        waterDownloadAndSaveUseCase: waterDownloadAndSaveUseCase,
      );

      expect(cubit.state, OnboardingInitial());
    });

    group("init test", () {
      test("water has local data error", () async {
        final cubit = OnboardingCubit(
          waterHasLocalDataUseCase: waterHasLocalDataUseCase,
          waterDownloadAndSaveUseCase: waterDownloadAndSaveUseCase,
        );

        when(
          waterHasLocalDataUseCase.call,
        ).thenAnswer(
          (_) => TaskEither.left(
            const Failure(message: "water has local data error"),
          ),
        );

        await cubit.init();

        expect(
          cubit.state,
          const OnboardingError(message: "water has local data error"),
        );
      });

      test("water has local data False", () async {
        final cubit = OnboardingCubit(
          waterHasLocalDataUseCase: waterHasLocalDataUseCase,
          waterDownloadAndSaveUseCase: waterDownloadAndSaveUseCase,
        );

        when(
          waterHasLocalDataUseCase.call,
        ).thenAnswer(
          (_) => TaskEither.right(
            const Success(value: false),
          ),
        );

        await cubit.init();

        expect(
          cubit.state,
          OnboardingReady(),
        );
      });

      test("water has local data True", () async {
        final cubit = OnboardingCubit(
          waterHasLocalDataUseCase: waterHasLocalDataUseCase,
          waterDownloadAndSaveUseCase: waterDownloadAndSaveUseCase,
        );

        when(
          waterHasLocalDataUseCase.call,
        ).thenAnswer(
          (_) => TaskEither.right(
            const Success(value: true),
          ),
        );

        await cubit.init();

        expect(
          cubit.state,
          OnboardingDone(),
        );
      });
    });

    group("download test", () {
      test("download and save error", () async {
        final cubit = OnboardingCubit(
          waterHasLocalDataUseCase: waterHasLocalDataUseCase,
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
          const OnboardingError(message: "download and save error"),
        );
      });

      test("download and save success", () async {
        final cubit = OnboardingCubit(
          waterHasLocalDataUseCase: waterHasLocalDataUseCase,
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
          OnboardingDone(),
        );
      });
    });
  });
}
