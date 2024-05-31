import 'dart:async';
import 'dart:isolate';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rando_point_deau/core/http/send_http_with_progress.dart';
import 'package:rando_point_deau/core/result/result.dart';
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
    final mainPort = ReceivePort("main");
    final token = RootIsolateToken.instance;
    final _IsolateParam param = (
      sendPort: mainPort.sendPort,
      useCase: waterDownloadAndSaveUseCase,
      token: token!,
    );

    final isolate = await Isolate.spawn(
      (_IsolateParam param) async {
        BackgroundIsolateBinaryMessenger.ensureInitialized(param.token);
        final res = await param.useCase
            .call(progressCallback: param.sendPort.send)
            .run();
        param.sendPort.send(res);
      },
      param,
    );

    await for (final message in mainPort) {
      if (message is Progress) {
        emit(OnboardingDownloading(message));
        if (message.isComplete) mainPort.close();
      }

      if (message is Either<Failure, Success<Empty>>) {
        isolate.kill();
        mainPort.close();
        message.fold(
          (failure) => emit(OnboardingError(message: failure.message)),
          (success) => emit(OnboardingDone()),
        );
      }
    }
  }
}

typedef _IsolateParam = ({
  SendPort sendPort,
  WaterDownloadAndSaveUseCase useCase,
  RootIsolateToken token,
});
