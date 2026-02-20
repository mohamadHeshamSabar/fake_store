import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;
  Failure({required this.errorMessage});
}

class ServerFailures extends Failure {
  ServerFailures({required super.errorMessage});

  factory ServerFailures.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.badResponse:
        return ServerFailures.fromResponse(
          response: dioException.response!.data,
          statusCode: dioException.response!.statusCode!,
        );
      case DioExceptionType.badCertificate:
        return ServerFailures(errorMessage: 'Bad Certificate');
      case DioExceptionType.connectionTimeout:
        return ServerFailures(errorMessage: 'Connection timeout with API');
      case DioExceptionType.sendTimeout:
        return ServerFailures(errorMessage: 'Send timeout with API');
      case DioExceptionType.receiveTimeout:
        return ServerFailures(errorMessage: 'Receive timeout with API');
      case DioExceptionType.cancel:
        return ServerFailures(errorMessage: 'The request was cancelled');
      case DioExceptionType.connectionError:
        return ServerFailures(errorMessage: 'Connection error');
      case DioExceptionType.unknown:
        return ServerFailures(errorMessage: 'Unknown error occurred');
    }
  }

  factory ServerFailures.fromResponse({
    required dynamic response,
    required int statusCode,
  }) {
    var message = response['message'];
    var errors = response['errors'];

    if (statusCode == 401) {
      return ServerFailures(errorMessage: message ?? 'Authorization error');
    }
    if (statusCode == 400 || statusCode == 403) {
      return ServerFailures(errorMessage: message ?? 'Authorization error');
    } else if (statusCode == 422) {
      return ServerFailures(
        errorMessage: errors.values.first.first ?? 'Validation error',
      );
    } else if (statusCode == 404) {
      return ServerFailures(
        errorMessage: message ?? 'Resource not found (404)',
      );
    } else if (statusCode == 500) {
      return ServerFailures(
        errorMessage: 'Internal server error, please try again later',
      );
    } else {
      return ServerFailures(
        errorMessage:
            'Unknown error occurred, please try again later $statusCode',
      );
    }
  }

  factory ServerFailures.fromResponses({required dynamic response}) {
    return ServerFailures(
      errorMessage: response['errors'] ?? 'Validation error',
    );
  }
}
