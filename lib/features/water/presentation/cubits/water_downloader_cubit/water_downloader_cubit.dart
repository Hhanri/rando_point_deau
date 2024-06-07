import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/core/utils/isolates.dart';
import 'package:rando_point_deau/core/value_objects/progress.dart';
import 'package:rando_point_deau/features/water/domain/use_cases/water_download_and_save_use_case.dart';

part 'water_downloader_state.dart';

class WaterDownloaderCubit extends Cubit<WaterDownloaderState> {
  final WaterDownloadAndSaveUseCase waterDownloadAndSaveUseCase;

  WaterDownloaderCubit({
    required this.waterDownloadAndSaveUseCase,
  }) : super(WaterDownloaderInitial());

  static Future<void> _downloadIsolateCallback(
    IsolateParam<WaterDownloadAndSaveUseCase> message,
  ) async {
    final res = await message.data
        .call(
          progressCallback: message.sendPort.send,
        )
        .run();
    res.fold(message.sendPort.send, message.sendPort.send);
  }

  Future<void> download() async {
    emit(WaterDownloaderLoading());

    await spawnIsolate<WaterDownloadAndSaveUseCase>(
      _downloadIsolateCallback,
      waterDownloadAndSaveUseCase,
      listenCallback: (message, completer) {
        if (message is Progress) emit(WaterDownloaderDownloading(message));
        if (message is Result) {
          if (message is Failure) emit(WaterDownloaderError(message.message));
          if (message is Success) emit(WaterDownloaderSuccess());
          completer.complete();
        }
      },
    );
  }
}
