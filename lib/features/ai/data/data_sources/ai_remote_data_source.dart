import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/base_response.dart';
import '../models/cancel_help_model.dart';

class AiRemoteDataSource {
  AiRemoteDataSource({required ApiClient apiClient})
      : _client = apiClient.client;

  final Dio _client;

  Future<BaseResponse<CancelHelpModel>> getCancelHelp({
    required String subscriptionName,
    String? platform,
    String? locale,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.smartCancelHelp,
      data: {
        'subscriptionName': subscriptionName,
        if (platform != null) 'platform': platform,
        if (locale != null) 'locale': locale,
      },
    );

    return BaseResponse.fromJson(
      response.data!,
          (json) => CancelHelpModel.fromJson(json as Map<String, dynamic>),
    );
  }
}