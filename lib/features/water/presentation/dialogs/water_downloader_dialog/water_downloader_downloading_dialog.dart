part of 'show_downloader_dialog.dart';

class _WaterDownloaderDownloadingDialog extends StatelessWidget {
  final Progress progress;
  const _WaterDownloaderDownloadingDialog({required this.progress});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(progress.title),
      content: LinearProgressIndicator(
        value: progress.progress / progress.total,
      ),
    );
  }
}
