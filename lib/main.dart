import 'package:flutter/material.dart';
import 'package:rando_point_deau/config/setup_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupSL();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Rando Point d'eau",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
