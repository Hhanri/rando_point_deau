import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando_point_deau/config/setup_container.dart';
import 'package:rando_point_deau/core/router/router.dart';
import 'package:rando_point_deau/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnboardingCubit>(
          create: (context) => sl.get<OnboardingCubit>(),
        ),
      ],
      child: const _App(),
    );
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Rando Point d'eau",
      routerConfig: AppRouter(
        onboardingCubit: BlocProvider.of<OnboardingCubit>(context),
      ).router,
    );
  }
}
