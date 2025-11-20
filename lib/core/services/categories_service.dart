import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class CategoriesService {
  final ApiClient _apiClient;

  CategoriesService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.client.get(ApiEndpoints.categories);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
