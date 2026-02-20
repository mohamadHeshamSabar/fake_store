import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../const/app_variables.dart';
import '../const/failure.dart';

/// A generic HTTP service using Dio + dartz Either.
/// All public methods return [Either<Failure, T>]:
///   - [Left<Failure>]  on any network / server error
///   - [Right<T>]       on success, parsed via [fromJson]
class InternetService {
  final Dio _dio;

  InternetService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppVariables.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        filter: (options, args) =>
            !args.isResponse || !args.hasUint8ListData,
      ),
    );
  }

  // ─── GET ────────────────────────────────────────────────────────────────────

  Future<Either<Failure, T>> getData<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endPoint,
        queryParameters: queryParameters,
      );
      return right(fromJson(response.data));
    } on DioException catch (e) {
      return left(ServerFailures.fromDioError(e));
    } catch (e) {
      return left(ServerFailures(errorMessage: e.toString()));
    }
  }

  // ─── POST ───────────────────────────────────────────────────────────────────

  Future<Either<Failure, T>> postData<T>({
    required String endPoint,
    required Object data,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.post(endPoint, data: data);
      return right(fromJson(response.data));
    } on DioException catch (e) {
      return left(ServerFailures.fromDioError(e));
    } catch (e) {
      return left(ServerFailures(errorMessage: e.toString()));
    }
  }

  // ─── PUT ────────────────────────────────────────────────────────────────────

  Future<Either<Failure, T>> putData<T>({
    required String endPoint,
    required Object data,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.put(endPoint, data: data);
      return right(fromJson(response.data));
    } on DioException catch (e) {
      return left(ServerFailures.fromDioError(e));
    } catch (e) {
      return left(ServerFailures(errorMessage: e.toString()));
    }
  }

  // ─── DELETE ─────────────────────────────────────────────────────────────────

  Future<Either<Failure, T>> deleteData<T>({
    required String endPoint,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.delete(endPoint);
      return right(fromJson(response.data));
    } on DioException catch (e) {
      return left(ServerFailures.fromDioError(e));
    } catch (e) {
      return left(ServerFailures(errorMessage: e.toString()));
    }
  }
}
