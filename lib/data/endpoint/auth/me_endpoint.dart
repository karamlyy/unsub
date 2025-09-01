import 'package:unsub/data/endpoint/base/endpoint.dart';
import 'package:unsub/presentation/utils/api_routes.dart';

class MeEndpoint extends Endpoint {
  @override
  String get route => ApiRoutes.me;

  @override
  HttpMethod get httpMethod => HttpMethod.get;
}


