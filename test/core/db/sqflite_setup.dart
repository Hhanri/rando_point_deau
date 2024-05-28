import 'package:flutter/widgets.dart';
import 'package:rando_point_deau/core/db/sqflite_setup.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> sqfliteTestDb() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  final db = await databaseFactoryFfi.openDatabase(
    inMemoryDatabasePath,
    options: SQFliteConfig.dbV1
  );
  return db;
}