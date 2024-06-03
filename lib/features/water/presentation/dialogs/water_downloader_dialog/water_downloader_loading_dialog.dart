part of 'show_downloader_dialog.dart';

class _WaterDownloaderLoadingDialog extends StatelessWidget {
  const _WaterDownloaderLoadingDialog();

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text("Download Data"),
      content: LinearProgressIndicator(),
    );
  }
}
