import 'package:unsub/data/endpoint/base/endpoint.dart';
import 'package:unsub/presentation/utils/api_routes.dart';

class CategoriesEndpoint extends Endpoint {
  CategoriesEndpoint();
  @override
  String get route => ApiRoutes.categories;

  @override
  HttpMethod get httpMethod => HttpMethod.get;
}
