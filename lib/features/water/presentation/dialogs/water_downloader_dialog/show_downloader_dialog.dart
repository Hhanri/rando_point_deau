import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando_point_deau/config/setup_container.dart';
import 'package:rando_point_deau/core/value_objects/progress.dart';
import 'package:rando_point_deau/features/water/presentation/cubits/water_downloader_cubit/water_downloader_cubit.dart';

part 'water_downloader_downloading_dialog.dart';
part 'water_downloader_error_dialog.dart';
part 'water_downloader_initial_dialog.dart';
part 'water_downloader_loading_dialog.dart';
part 'water_downloader_success_dialog.dart';

Future<void> showWaterDownloadDialog({
  required BuildContext context,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return BlocProvider(
        create: (_) => sl.get<WaterDownloaderCubit>(),
        child: BlocBuilder<WaterDownloaderCubit, WaterDownloaderState>(
          builder: (context, state) {
            return switch (state) {
              WaterDownloaderInitial() => const _WaterDownloaderInitialDialog(),
              WaterDownloaderError() =>
                _WaterDownloaderErrorDialog(message: state.message),
              WaterDownloaderSuccess() => const _WaterDownloaderSuccessDialog(),
              WaterDownloaderDownloading() =>
                _WaterDownloaderDownloadingDialog(progress: state.progress),
              WaterDownloaderLoading() => const _WaterDownloaderLoadingDialog(),
            };
          },
        ),
      );
    },
  );
}
