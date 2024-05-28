import 'package:rando_point_deau/core/result/result.dart';

abstract interface class ApiResponse extends Result {
  final bool success;

  const ApiResponse({
    required this.success
  });
}

class ApiSuccess<T> extends ApiResponse implements Success<T>{

  @override
  final T value;

  const ApiSuccess({
    required this.value,
  }) : super(
    success: true
  );

  factory ApiSuccess.parse(Object? data, T Function(Object? source) transform) {
    return ApiSuccess<T>(
      value: transform(data)
    );
  }

  @override
  List<Object?> get props => [value, success];

}

class ApiFailure extends ApiResponse implements Failure {

  @override
  final int? code;

  @override
  final String message;

  const ApiFailure({
    this.code,
    required this.message,
  }) : super(
    success: false
  );

  @override
  List<Object?> get props => [code, message, success];

}