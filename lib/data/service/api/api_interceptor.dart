import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/service/preferences/preferences.dart';
import 'package:unsub/presentation/navigation/app_router.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/utils/api_routes.dart';

class ApiInterceptor extends Interceptor {
  final Dio dio;

  ApiInterceptor({required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await PreferencesService.instance;
    options.headers["accept"] = "application/json";

    final isAuthPath = options.path.contains(ApiRoutes.login) || options.path.contains(ApiRoutes.refreshToken);

    final accessToken = prefs.accessToken;
    if (!isAuthPath && accessToken != null && accessToken.isNotEmpty) {
      options.headers["Authorization"] =
      accessToken.startsWith("Bearer ") ? accessToken : "Bearer $accessToken";
    }

    log("HEADERS: ${options.headers}");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final prefs = await PreferencesService.instance;

    final isAuthPath =
        err.requestOptions.path.contains(ApiRoutes.login) ||
            err.requestOptions.path.contains(ApiRoutes.refreshToken);

    final refreshToken = prefs.refreshToken;
    if (err.response?.statusCode == 401 &&
        !isAuthPath &&
        refreshToken != null &&
        refreshToken.isNotEmpty &&
        (err.requestOptions.extra["__retriedWithRefresh__"] != true)) {
      final RequestOptions options = err.requestOptions;

      try {
        final refreshResult = await dio.post(
          ApiRoutes.refreshToken,
          data: {"refreshToken": refreshToken},
          options: Options(),
        );

        String? newAccessToken;
        String? newRefreshToken;
        final data = refreshResult.data;
        if (data is Map<String, dynamic>) {
          final inner = (data["data"] is Map<String, dynamic>)
              ? data["data"] as Map<String, dynamic>
              : data;
          newAccessToken = inner["accessToken"] as String?;
          newRefreshToken = inner["refreshToken"] as String?;
        }

        if (newAccessToken == null || newAccessToken.isEmpty) {
          await _clearSession();
          return handler.reject(err);
        }

        await prefs.setAccessToken(newAccessToken);
        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await prefs.setRefreshToken(newRefreshToken);
        }

        options.headers["Authorization"] = newAccessToken.startsWith("Bearer ")
            ? newAccessToken
            : "Bearer $newAccessToken";

        options.extra["__retriedWithRefresh__"] = true;

        final response = await dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        await _clearSession();
        return handler.reject(err);
      }
    }
    if (err.response?.statusCode == 429) {
      await _clearSession();
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          error: HttpException(
            error: ErrorMessage(
              message: "Too many requests. Please try again later.",
              code: 429,
            ),
          ),
        ),
      );
    }

    // ✅ Daha informativ error parsing
    String errorMessage = "An unknown error occurred";
    int? statusCode = err.response?.statusCode;

    if (err.type == DioExceptionType.connectionError) {
      errorMessage = "Network connection error";
    }

    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      if (data['messages'] is List) {
        errorMessage = (data['messages'] as List).join(", ");
      } else if (data['message'] is String) {
        errorMessage = data['message'] as String;
      } else if (data['error'] is String) {
        errorMessage = data['error'] as String;
      } else if (data['error'] is Map && (data['error'] as Map)['message'] is String) {
        errorMessage = (data['error'] as Map)['message'] as String;
      }
    } else if (data is String && data.isNotEmpty) {
      errorMessage = data;
    } else if (err.message != null && err.message!.isNotEmpty) {
      errorMessage = err.message!;
    } else if (statusCode != null) {
      errorMessage = "HTTP $statusCode";
    }

    log("DIO ERROR => type: ${err.type} status: $statusCode data: ${err.response?.data}");
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: HttpException(
          error: ErrorMessage(
            message: errorMessage,
            code: statusCode,
          ),
        ),
      ),
    );
  }

  Future<void> _clearSession() async {
    final prefs = await PreferencesService.instance;
    await prefs.clear();
    await prefs.setAuthorizationPassed(false);
    Navigation.pushNamedAndRemoveUntil(Routes.login, arguments: false);
  }
}