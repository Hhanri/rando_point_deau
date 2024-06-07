import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_has_local_data_use_case.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final WaterHasLocalDataUseCase waterHasLocalDataUseCase;

  OnboardingCubit({
    required this.waterHasLocalDataUseCase,
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
}
