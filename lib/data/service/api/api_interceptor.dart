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
    options.headers["accept"] = "*/*";
    options.headers["Accept-Encoding"] = "gzip, deflate, br";

    if (prefs.accessToken != null) {
      options.headers["Authorization"] = prefs.accessToken;
    }

    log("HEADERS: ${options.headers}");
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final prefs = await PreferencesService.instance;

    if (err.response?.statusCode == 401) {
      RequestOptions options = err.requestOptions;

      try {
        final refreshResult = await dio.post(
          ApiRoutes.refreshToken,
          options: Options(
            headers: {
              "Refresh-Token": prefs.refreshToken,
            },
          ),
        );

        final newAccessToken = refreshResult.data["token"];
        await prefs.setAccessToken(newAccessToken);
        options.headers["Authorization"] = newAccessToken;

        final response = await dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        await _clearSession();
        return handler.reject(err);
      }
    }

    String errorMessage = "An unknown error occurred";

    if (err.response != null) {
      final statusCode = err.response?.statusCode;
      final data = err.response?.data;

      if (data is Map<String, dynamic>) {
        if (data.containsKey('code') && data['code'] == "429") {
          _clearSession();
          return;
        } else if (data.containsKey('messages') && data['messages'] is List) {
          errorMessage = data['messages'].join(", ");
        } else if (data.containsKey('message')) {
          errorMessage = data['message'];
        }
      } else if (data is String) {
        errorMessage = data;
      }

      log("ERROR[$statusCode] => MESSAGE: $errorMessage");
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: HttpException(
          error: ErrorMessage(
            message: errorMessage,
            code: err.response?.statusCode,
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
