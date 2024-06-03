part of 'show_downloader_dialog.dart';

class _WaterDownloaderErrorDialog extends StatelessWidget {
  final String message;
  const _WaterDownloaderErrorDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Download Error"),
      content: Text(message),
      actions: [
        SimpleDialogOption(
          onPressed: context.read<WaterDownloaderCubit>().download,
          child: const Text("Retry"),
        )
      ],
    );
  }
}
