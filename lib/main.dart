import 'package:flutter/material.dart';
import 'package:rando_point_deau/app.dart';
import 'package:rando_point_deau/config/flutter_map_setup.dart';
import 'package:rando_point_deau/config/setup_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupSL(
    [
      flutterMapSetupContainer,
    ],
  );
  runApp(const AppWrapper());
}
