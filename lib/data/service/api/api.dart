import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:retry/retry.dart';
import 'package:unsub/data/endpoint/base/endpoint.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/model/base/response_model.dart';
import 'package:unsub/data/service/api/api_interceptor.dart';
import 'package:unsub/data/service/api/logging.dart';

class ApiService {
  final prodUrl = "https://api.karam.az/karam/api/v0/";
  final Dio _dio;

  ApiService() : _dio = Dio() {
    _dio.options
      ..contentType = "application/json"
      ..baseUrl = prodUrl;

    _dio.interceptors.add(ApiInterceptor(dio: _dio));
    _dio.interceptors.add(DebugLogging());

    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<Either<HttpException, T>> task<T>(Endpoint endpoint) async {
    const r = RetryOptions(
      maxAttempts: 3,
      delayFactor: Duration(seconds: 2),
    );

    try {
      final result = await r.retry(
        () => _executeRequest(endpoint),
        retryIf: (e) => e is DioException && _shouldRetry(e),
      );
      return Right(await _handle<T>(result, endpoint));
    } on DioException catch (e) {
      return Left(await _handleError(e));
    }
  }


  Future<Response> _executeRequest(Endpoint endpoint) async {
    switch (endpoint.httpMethod) {
      case HttpMethod.get:
        return _dio.get(
          endpoint.route,
          queryParameters: endpoint.queryParameters,
        );
      case HttpMethod.post:
        return _dio.post(
          endpoint.route,
          data: endpoint.body,
          queryParameters: endpoint.queryParameters,
        );
      case HttpMethod.put:
        return _dio.put(
          endpoint.route,
          data: endpoint.body,
          queryParameters: endpoint.queryParameters,
        );
      case HttpMethod.delete:
        return _dio.delete(
          endpoint.route,
          data: endpoint.body,
          queryParameters: endpoint.queryParameters,
        );
      }
  }

  Future<dynamic> _handle<T>(Response response, Endpoint endpoint) async {
    if (![200, 201, 203, 204].contains(response.statusCode)) {
      return HttpException(
        error: ErrorMessage(
          message: response.statusMessage ?? "Unknown error happened",
          code: response.statusCode,
        ),
      );
    }

    try {
      final request = ResponseModel<T>.fromJson(response.data);
      if (request.hasData) {
        return request.response;
      } else {
        return request.message;
      }
    } on TypeError catch (e) {
      log("TYPE ERROR HERE => ${e.stackTrace.toString()}");
      return HttpException(
        error: ErrorMessage(
          message: e.stackTrace.toString(),
          code: response.statusCode,
        ),
      );
    }
  }

  Future<HttpException> _handleError(DioException e) async {
    return e.error as HttpException;
  }

  bool _shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.sendTimeout;
  }
}
