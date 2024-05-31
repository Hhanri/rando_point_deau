import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando_point_deau/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [Placeholder(), Text("description application")],
      ),
      bottomNavigationBar: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          if (state is OnboardingDownloading) {
            return LinearProgressIndicator(
              value: state.progress.received / state.progress.total,
            );
          }
          if (state is OnboardingReady) {
            return FilledButton(
              onPressed: context.read<OnboardingCubit>().download,
              child: const Text("download"),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
