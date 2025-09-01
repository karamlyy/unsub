import 'package:unsub/data/endpoint/base/endpoint.dart';
import 'package:unsub/presentation/utils/api_routes.dart';

class GetPaymentMethodsEndpoint extends Endpoint {
  GetPaymentMethodsEndpoint();
  @override
  String get route => ApiRoutes.paymentMethods;

  @override
  HttpMethod get httpMethod => HttpMethod.get;

}