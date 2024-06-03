import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando_point_deau/core/assets/svg_assets.dart';
import 'package:rando_point_deau/core/theme/padding.dart';
import 'package:rando_point_deau/core/theme/spacing.dart';
import 'package:rando_point_deau/core/theme/text_theme.dart';
import 'package:rando_point_deau/core/widgets/svg_widget.dart';
import 'package:rando_point_deau/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:rando_point_deau/features/water/presentation/dialogs/water_downloader_dialog/show_downloader_dialog.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: AppPadding.h32,
        child: Column(
          children: [
            const SvgWidget(path: SvgAssets.nature),
            Text(
              "Rando Point D'eau",
              style: context.textTheme.titleLarge,
            ),
            AppSpacing.h12,
            Text(
              "Welcome to Rando Point D'eau, the only app you need to find water sources during yout trekking !\nStart now by syncing your device with the latest data !",
              style: context.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      bottomNavigationBar: FilledButton(
        onPressed: () async {
          await showWaterDownloadDialog(context: context);
          if (context.mounted) await context.read<OnboardingCubit>().init();
        },
        child: const Text("Start !"),
      ),
    );
  }
}
