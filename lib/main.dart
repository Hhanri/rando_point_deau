import 'package:flutter/material.dart';
import 'package:rando_point_deau/config/flutter_map_setup.dart';
import 'package:rando_point_deau/config/setup_container.dart';
import 'package:rando_point_deau/features/onboarding/presentation/pages/onboarding_page_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupSL(
    [
      flutterMapSetupContainer,
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Rando Point d'eau",
      home: OnboardingPageWrapper(),
    );
  }
}
