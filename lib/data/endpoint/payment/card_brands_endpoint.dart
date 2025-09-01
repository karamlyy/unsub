import 'package:unsub/data/endpoint/base/endpoint.dart';
import 'package:unsub/presentation/utils/api_routes.dart';

class CardBrandsEndpoint extends Endpoint {
  CardBrandsEndpoint();
  @override
  String get route => ApiRoutes.cardBrands;

  @override
  HttpMethod get httpMethod => HttpMethod.get;

}