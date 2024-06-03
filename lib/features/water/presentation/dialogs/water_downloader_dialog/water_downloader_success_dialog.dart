part of 'show_downloader_dialog.dart';

class _WaterDownloaderSuccessDialog extends StatelessWidget {
  const _WaterDownloaderSuccessDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Download Success"),
      content: const Text("Your device is now synced with the latest data !"),
      actions: [
        SimpleDialogOption(
          onPressed: Navigator.of(context).pop,
          child: const Text("Close"),
        )
      ],
    );
  }
}
