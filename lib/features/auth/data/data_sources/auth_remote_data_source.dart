import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/base_response.dart';
import '../models/auth_response_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({required ApiClient apiClient})
    : _client = apiClient.client;

  final Dio _client;

  Future<BaseResponse<AuthPayload>> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    return BaseResponse.fromJson(
      response.data!,
      (json) => AuthPayload.fromJson(json! as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<AuthPayload>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: {'name': name, 'email': email, 'password': password},
    );

    return BaseResponse.fromJson(
      response.data!,
      (json) => AuthPayload.fromJson(json! as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<AuthPayload>> refresh(String refreshToken) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.refresh,
      data: {'refreshToken': refreshToken},
    );

    return BaseResponse.fromJson(
      response.data!,
      (json) => AuthPayload.fromJson(json! as Map<String, dynamic>),
    );
  }

  Future<void> clearFcmToken() async {
    try {
      await _client.patch<Map<String, dynamic>>(
        ApiEndpoints.updateFcmToken,
        data: {'fcmToken': ''},
      );
    } catch (_) {
      // logout zamanı bu çağırış uğursuz olsa da app davam etməlidir
    }
  }
}
