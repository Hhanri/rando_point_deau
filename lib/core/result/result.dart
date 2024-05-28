import 'package:equatable/equatable.dart';

export 'package:rando_point_deau/core/result/api_response.dart';
export 'package:rando_point_deau/core/result/empty.dart';
export 'package:rando_point_deau/core/result/execute.dart';
export 'package:rando_point_deau/core/result/failure.dart';
export 'package:rando_point_deau/core/result/success.dart';

abstract class Result extends Equatable {

  const Result();

}