import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/base_response.dart';
import '../models/subscription_model.dart';

class SubscriptionsRemoteDataSource {
  SubscriptionsRemoteDataSource({required ApiClient apiClient})
    : _client = apiClient.client;

  final Dio _client;

  Future<BaseResponse<List<SubscriptionModel>>> getSubscriptions() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.subscriptions,
    );

    return BaseResponse.fromJson(response.data!, (json) {
      final list = json as List<dynamic>;
      return list
          .map((e) => SubscriptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  Future<BaseResponse<SubscriptionModel>> createSubscription({
    required String name,
    String? category,
    required double price,
    required String currency,
    required String billingCycle,
    required DateTime firstPaymentDate,
    bool isActive = true,
    String? notes,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.subscriptions,
      data: {
        'name': name,
        'category': category,
        'price': price,
        'currency': currency,
        'billingCycle': billingCycle,
        'firstPaymentDate': firstPaymentDate.toIso8601String().split('T').first,
        'isActive': isActive,
        'notes': notes,
      },
    );

    return BaseResponse.fromJson(
      response.data!,
      (json) => SubscriptionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<SubscriptionModel>> updateSubscription({
    required int id,
    String? name,
    String? category,
    double? price,
    String? currency,
    String? billingCycle,
    DateTime? firstPaymentDate,
    bool? isActive,
    String? notes,
  }) async {
    final Map<String, dynamic> body = {};

    if (name != null) body['name'] = name;
    if (category != null) body['category'] = category;
    if (price != null) body['price'] = price;
    if (currency != null) body['currency'] = currency;
    if (billingCycle != null) body['billingCycle'] = billingCycle;
    if (firstPaymentDate != null) {
      body['firstPaymentDate'] = firstPaymentDate
          .toIso8601String()
          .split('T')
          .first;
    }
    if (isActive != null) body['isActive'] = isActive;
    if (notes != null) body['notes'] = notes;

    final response = await _client.put<Map<String, dynamic>>(
      ApiEndpoints.subscriptionById(id),
      data: body,
    );

    return BaseResponse.fromJson(
      response.data!,
      (json) => SubscriptionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<void>> deleteSubscription(int id) async {
    final response = await _client.delete<Map<String, dynamic>>(
      ApiEndpoints.subscriptionById(id),
    );

    return BaseResponse.fromJson(response.data!, (_) => null);
  }
}
