import 'package:dio/dio.dart';
import 'failures.dart';

Failure mapDioErrorToFailure(DioException e) {
  // backend BaseResponse formatında error göndərirsə
  final data = e.response?.data;
  String? backendMessage;

  if (data is Map && data['message'] != null) {
    backendMessage = data['message']?.toString();
  }

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return NetworkFailure(backendMessage ?? 'Şəbəkə xətası. Yenidən yoxla.');

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode ?? 0;
      if (statusCode == 401 || statusCode == 403) {
        return AuthFailure(backendMessage ?? 'Giriş icazən yoxdur.');
      }
      return ServerFailure(
        backendMessage ??
            'Server xətası (${e.response?.statusCode ?? 'naməlum'}).',
      );

    case DioExceptionType.cancel:
      return UnexpectedFailure('Sorğu ləğv edildi.');
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
    default:
      return UnexpectedFailure(backendMessage ?? 'Naməlum xəta baş verdi.');
  }
}
