import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/base_response.dart';
import '../../../auth/data/models/auth_response_model.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource({required ApiClient apiClient})
    : _client = apiClient.client;

  final Dio _client;

  Future<BaseResponse<UserModel>> getProfile() async {
    final response = await _client.get<Map<String, dynamic>>(ApiEndpoints.me);

    return BaseResponse.fromJson(
      response.data!,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
