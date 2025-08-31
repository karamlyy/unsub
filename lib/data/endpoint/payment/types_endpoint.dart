import 'package:unsub/data/endpoint/base/endpoint.dart';
import 'package:unsub/presentation/utils/api_routes.dart';

class TypesEndpoint extends Endpoint {
  TypesEndpoint();
  @override
  String get route => ApiRoutes.types;

  @override
  HttpMethod get httpMethod => HttpMethod.get;

}