import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando_point_deau/core/http/send_http_with_progress.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_download_and_save_use_case.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_has_local_data_use_case.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final WaterHasLocalDataUseCase waterHasLocalDataUseCase;
  final WaterDownloadAndSaveUseCase waterDownloadAndSaveUseCase;

  OnboardingCubit({
    required this.waterHasLocalDataUseCase,
    required this.waterDownloadAndSaveUseCase,
  }) : super(OnboardingInitial());

  Future<void> init() async {
    final res = await waterHasLocalDataUseCase.call().run();
    res.fold(
      (failure) => emit(OnboardingError(message: failure.message)),
      (success) {
        if (success.value) {
          return emit(OnboardingDone());
        }
        return emit(OnboardingReady());
      },
    );
  }

  void emitDownloadProgress(Progress progress) {
    emit(OnboardingDownloading(progress));
  }

  Future<void> download() async {
    final res = await waterDownloadAndSaveUseCase
        .call(progressCallback: emitDownloadProgress)
        .run();

    res.fold(
      (failure) => emit(OnboardingError(message: failure.message)),
      (success) => emit(OnboardingDone()),
    );
  }
}
