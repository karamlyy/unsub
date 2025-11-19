import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/auth_response_model.dart';

class AuthRepository {
  AuthRepository({
    required ApiClient apiClient,
    required SecureStorage secureStorage,
  }) : _remote = AuthRemoteDataSource(apiClient: apiClient),
       _secureStorage = secureStorage;

  final AuthRemoteDataSource _remote;
  final SecureStorage _secureStorage;

  Future<Either<Failure, AuthPayload>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _remote.login(email: email, password: password);

      if (!res.success || res.data == null) {
        return left(ServerFailure(res.message));
      }

      await _secureStorage.saveTokens(
        accessToken: res.data!.accessToken,
        refreshToken: res.data!.refreshToken,
      );

      return right(res.data!);
    } on DioException catch (e) {
      return left(mapDioErrorToFailure(e));
    } catch (_) {
      return left(UnexpectedFailure('Naməlum xəta baş verdi'));
    }
  }

  Future<Either<Failure, AuthPayload>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _remote.register(
        name: name,
        email: email,
        password: password,
      );

      if (!res.success || res.data == null) {
        return left(ServerFailure(res.message));
      }

      await _secureStorage.saveTokens(
        accessToken: res.data!.accessToken,
        refreshToken: res.data!.refreshToken,
      );

      return right(res.data!);
    } on DioException catch (e) {
      return left(mapDioErrorToFailure(e));
    } catch (_) {
      return left(UnexpectedFailure('Naməlum xəta baş verdi'));
    }
  }

  Future<void> logout() async {
    // Backend-də user-in FCM tokenini təmizlə
    await _remote.clearFcmToken();

    // Lokal access/refresh tokenləri sil
    await _secureStorage.clearTokens();
  }

  Future<bool> hasTokens() async {
    final token = await _secureStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
