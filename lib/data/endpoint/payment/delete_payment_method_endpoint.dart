import 'package:unsub/data/endpoint/base/endpoint.dart';
import 'package:unsub/presentation/utils/api_routes.dart';

class DeletePaymentMethodEndpoint extends Endpoint {
  final String id;

  DeletePaymentMethodEndpoint(this.id);

  @override
  String get route => '${ApiRoutes.paymentMethodById}/$id';

  @override
  HttpMethod get httpMethod => HttpMethod.delete;

  @override
  Map<String, dynamic>? get body => null;
}

