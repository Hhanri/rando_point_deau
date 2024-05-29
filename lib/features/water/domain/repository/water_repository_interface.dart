import 'package:fpdart/fpdart.dart';
import 'package:rando_point_deau/core/http/send_http_with_progress.dart';
import 'package:rando_point_deau/core/result/result.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_entity.dart';
import 'package:rando_point_deau/features/water/domain/entities/water_source_filter_entity.dart';

abstract interface class WaterRepositoryInterface {
  TaskEither<Failure, EmptySuccess> downloadAndSave({
    ProgressCallback? progressCallback,
  });

  TaskEither<Failure, Success<List<WaterSourceEntity>>> search(
    WaterSourceFilterEntity filter,
  );

  TaskEither<Failure, Success<bool>> hasLocalData();
}
