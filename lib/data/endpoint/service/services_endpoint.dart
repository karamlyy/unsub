import 'package:unsub/data/endpoint/base/endpoint.dart';
import 'package:unsub/presentation/utils/api_routes.dart';

class ServicesEndpoint extends Endpoint {
  ServicesEndpoint();
  @override
  String get route => ApiRoutes.services;

  @override
  HttpMethod get httpMethod => HttpMethod.get;

}