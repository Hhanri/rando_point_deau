import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> setupSharedPreferencesTest() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  return await SharedPreferences.getInstance();
}