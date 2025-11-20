import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required SecureStorage secureStorage, required Dio dio})
    : _secureStorage = secureStorage,
      _dio = dio;

  final SecureStorage _secureStorage;
  final Dio _dio;

  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  bool _shouldTryRefresh(RequestOptions request) {
    final path = request.path;
    // Auth endpoint-lərin özündə refresh etməyək
    if (path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh')) {
      return false;
    }
    return true;
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Refresh yalnız 401 badResponse və uyğun endpoint-lər üçün
    final statusCode = err.response?.statusCode;
    if (statusCode == 401 &&
        !_isRefreshing &&
        _shouldTryRefresh(err.requestOptions)) {
      _isRefreshing = true;

      try {
        final refreshToken = await _secureStorage.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          // refresh token yoxdursa, normal error kimi ötür
          await _secureStorage.clearTokens();
          handler.next(err);
          return;
        }

        // Refresh üçün ayrıca Dio yaradırıq ki, interceptor loop olmasın
        final refreshDio = Dio(
          BaseOptions(
            baseUrl: err.requestOptions.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

        final refreshResponse = await refreshDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        final body = refreshResponse.data;
        if (body == null || body['success'] != true || body['data'] == null) {
          // refresh də alınmadı
          await _secureStorage.clearTokens();
          handler.next(err);
          return;
        }

        final data = body['data'] as Map<String, dynamic>;
        final newAccessToken = data['accessToken'] as String;
        final newRefreshToken = data['refreshToken'] as String;

        // Yeni tokenləri yadda saxla
        await _secureStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        // Orijinal request-i yeniləyib təkrar göndər
        final RequestOptions requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        final Response<dynamic> retryResponse = await _dio.fetch(
          requestOptions,
        );

        // Artıq bu cavabı istifadə et
        handler.resolve(retryResponse);
        return;
      } catch (_) {
        // Hər ehtimala qarşı tokenləri təmizləyək
        await _secureStorage.clearTokens();
        handler.next(err);
        return;
      } finally {
        _isRefreshing = false;
      }
    }

    // Əgər refresh şərtlərinə düşmürsə, normal error kimi ötür
    super.onError(err, handler);
  }
}
