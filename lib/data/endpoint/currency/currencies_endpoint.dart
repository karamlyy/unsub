import 'package:unsub/data/endpoint/base/endpoint.dart';
import 'package:unsub/presentation/utils/api_routes.dart';

class CurrenciesEndpoint extends Endpoint {
  CurrenciesEndpoint();
  @override
  String get route => ApiRoutes.currencies;

  @override
  HttpMethod get httpMethod => HttpMethod.get;

}