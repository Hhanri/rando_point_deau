import 'dart:async';
import 'dart:isolate';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/core/value_objects/progress.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_download_and_save_use_case.dart';

part 'water_downloader_state.dart';

class WaterDownloaderCubit extends Cubit<WaterDownloaderState> {
  final WaterDownloadAndSaveUseCase waterDownloadAndSaveUseCase;

  WaterDownloaderCubit({
    required this.waterDownloadAndSaveUseCase,
  }) : super(WaterDownloaderInitial());

  Future<void> download() async {
    emit(WaterDownloaderLoading());
    final mainPort = ReceivePort("main");
    final token = RootIsolateToken.instance;
    final _IsolateParam param = (
      sendPort: mainPort.sendPort,
      useCase: waterDownloadAndSaveUseCase,
      token: token!,
    );

    final completer = Completer<void>();

    final isolate = await Isolate.spawn(
      (_IsolateParam param) async {
        BackgroundIsolateBinaryMessenger.ensureInitialized(param.token);
        final res = await param.useCase
            .call(progressCallback: param.sendPort.send)
            .run();
        res.fold(param.sendPort.send, param.sendPort.send);
      },
      param,
    );

    mainPort.listen((message) {
      if (message is Progress) emit(WaterDownloaderDownloading(message));

      if (message is Result) {
        if (message is Failure) emit(WaterDownloaderError(message.message));
        if (message is Success) emit(WaterDownloaderSuccess());
        completer.complete();
      }
    });

    await completer.future;
    isolate.kill();
    mainPort.close();
  }
}

typedef _IsolateParam = ({
  SendPort sendPort,
  WaterDownloadAndSaveUseCase useCase,
  RootIsolateToken token,
});
