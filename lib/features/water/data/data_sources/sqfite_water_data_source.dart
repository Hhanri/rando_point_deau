import 'dart:math';

import 'package:rando_point_deau/core/db/sqflite_setup.dart';
import 'package:rando_point_deau/core/result/empty.dart';
import 'package:rando_point_deau/core/value_objects/progress.dart';
import 'package:rando_point_deau/features/water/data/data_sources/water_local_data_source_interface.dart';
import 'package:rando_point_deau/features/water/data/models/sqflite_water_source_model.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_filter_entity.dart';
import 'package:rando_point_deau/features/water/domain/enum/water_enum.dart';
import 'package:sqflite/sqflite.dart';

final class SQFliteWaterDataSource implements WaterLocalDataSourceInterface {
  final Database db;

  SQFliteWaterDataSource(this.db);

  @override
  Future<List<WaterSourceEntity>> get(WaterSourceFilterEntity filter) async {
    String query = '''lat <= ?
      AND lat >= ?
      AND lng <= ?
      AND lng >= ?''';

    final List<dynamic> queryArgs = [
      filter.bounds.tl.lat,
      filter.bounds.br.lat,
      filter.bounds.br.lng,
      filter.bounds.tl.lng,
    ];

    if (filter.waterTypes.isNotEmpty &&
        filter.waterTypes.length != Water.values.length) {
      query += '''\nAND type IN (?)''';
      queryArgs.add(filter.waterTypes.map((e) => e.name).join(", "));
    }

    final res = await db.query(
      SQFliteConfig.waterSourcesTable,
      where: query,
      whereArgs: queryArgs,
    );
    return res.map(SQFliteWaterSourceModel.fromJson).toList();
  }

  @override
  Future<List<WaterSourceEntity>> getWrapAround(
      WaterSourceFilterEntity filter) async {
    String query = '''lat <= ?
      AND lat >= ?
      AND (
        lng >= ?
        OR lng <= ?
      )''';

    final List<dynamic> queryArgs = [
      filter.bounds.tl.lat,
      filter.bounds.br.lat,
      filter.bounds.tl.lng,
      filter.bounds.br.lng,
    ];

    if (filter.waterTypes.isNotEmpty &&
        filter.waterTypes.length != Water.values.length) {
      query += '''\nAND type IN (?)''';
      queryArgs.add(filter.waterTypes.map((e) => e.name).join(", "));
    }

    final res = await db.query(
      SQFliteConfig.waterSourcesTable,
      where: query,
      whereArgs: queryArgs,
    );
    return res.map(SQFliteWaterSourceModel.fromJson).toList();
  }

  @override
  Future<bool> hasData() async {
    final res = await db.query(SQFliteConfig.waterSourcesTable, limit: 1);
    return res.isNotEmpty;
  }

  @override
  Future<Empty> insertWaterSources(
    List<WaterSourceEntity> waterSources, {
    StepProgress? stepProgress,
    ProgressCallback? progressCallback,
  }) async {
    const int batchSize = 20000;
    final batchNum = (waterSources.length / batchSize).ceil();

    int treated = 0;

    Future<void> handleBatch(
      int batchN,
      int batchSize,
      List<WaterSourceEntity> waterSources,
      ProgressCallback? progressCallback,
    ) async {
      final batch = db.batch();
      final begin = batchSize * batchN;
      final end = min(batchSize * (batchN + 1), waterSources.length);
      for (int i = begin; i < end; i++) {
        batch.insert(SQFliteConfig.waterSourcesTable, waterSources[i].toJson());
      }
      await batch.commit();
      treated += (end - begin);

      final Progress progress = Progress.dbInsert(
        progress: treated,
        total: waterSources.length,
        stepProgress: stepProgress,
      );

      progressCallback?.call(progress);
    }

    final List<Future<void>> batchHandlers = [];
    for (int i = 0; i < batchNum; i++) {
      batchHandlers.add(
        handleBatch(
          i,
          batchSize,
          waterSources,
          progressCallback,
        ),
      );
    }

    await Future.wait(batchHandlers);
    return const Empty();
  }
}
