import 'package:fpdart/fpdart.dart';
import 'package:rando_point_deau/core/result/api_response.dart';
import 'package:rando_point_deau/core/result/failure.dart';
import 'package:rando_point_deau/core/result/success.dart';

TaskEither<Failure, Success<T>> execute<T>(
  Future<T> Function() function
) {
  return TaskEither(() => _execute(function));
}

Future<Either<Failure, Success<T>>> _execute<T>(
  Future<T> Function() function
) async {
  try {
    final res = await function();
    return Right(Success(value: res));
  } on Failure catch(e) {
    return Left(e);
  } catch(e) {
    return Left(Failure(message: e.toString()));
  }
}

TaskEither<ApiFailure, ApiSuccess<T>> executeApi<T>(
  Future<T> Function() function
) {
  return TaskEither(() => _executeApi(function));
}

Future<Either<ApiFailure, ApiSuccess<T>>> _executeApi<T>(
  Future<T> Function() function
) async {
  try {
    final res = await function();
    return Right(ApiSuccess<T>(value: res));
  } on ApiFailure catch(e) {
    return Left(e);
  } catch(e) {
    return Left(ApiFailure(message: e.toString()));
  }
}