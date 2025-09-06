import 'package:unsub/data/endpoint/base/endpoint.dart';
import 'package:unsub/presentation/utils/api_routes.dart';

class SubscriptionsEndpoint extends Endpoint {
  SubscriptionsEndpoint();
  @override
  String get route => ApiRoutes.subscriptions;

  @override
  HttpMethod get httpMethod => HttpMethod.get;
}
