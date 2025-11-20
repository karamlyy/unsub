import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';

class ApiClient {
  ApiClient({required SecureStorage secureStorage})
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ) {
    _dio.interceptors.add(
      AuthInterceptor(secureStorage: secureStorage, dio: _dio),
    );
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  final Dio _dio;

  Dio get client => _dio;
}
