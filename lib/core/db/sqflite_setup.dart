import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract final class SQFliteConfig {
  static const waterSourcesTable = "water_sources";

  static final dbV1 = OpenDatabaseOptions(
    version: 1,
    onCreate: (db, version) async {
      _createWaterSourcesTable(db);
    },
  );

  static Future<void> _createWaterSourcesTable(Database db) {
    return db.execute('''CREATE TABLE $waterSourcesTable (
      id TEXT PRIMARY_KEY,
      name TEXT,
      lat NUMBER,
      lng NUMBER,
      type TEXT
    );''');
  }

  static Future<Database> openDatabase(
    String name, {
    OpenDatabaseOptions? options,
  }) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, name);
    return await databaseFactory.openDatabase(
      path,
      options: options ?? dbV1,
    );
  }
}
