import 'package:flutter/material.dart';
import 'package:rando_point_deau/features/water/presentation/dialogs/water_downloader_dialog/show_downloader_dialog.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          Placeholder(),
          Text("description application"),
        ],
      ),
      bottomNavigationBar: FilledButton(
        onPressed: () => showWaterDownloadDialog(context: context),
        child: const Text("download"),
      ),
    );
  }
}
