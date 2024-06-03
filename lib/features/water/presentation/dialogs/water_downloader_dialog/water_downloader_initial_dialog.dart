part of 'show_downloader_dialog.dart';

class _WaterDownloaderInitialDialog extends StatelessWidget {
  const _WaterDownloaderInitialDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Download Data"),
      content: const Text("Press CONTINUE to sync data on your device"),
      actions: [
        SimpleDialogOption(
          onPressed: context.read<WaterDownloaderCubit>().download,
          child: const Text("Continue"),
        ),
      ],
    );
  }
}
