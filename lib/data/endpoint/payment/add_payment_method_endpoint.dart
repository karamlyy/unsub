import 'package:unsub/data/endpoint/base/endpoint.dart';
import 'package:unsub/presentation/utils/api_routes.dart';

class AddPaymentMethodEndpoint extends Endpoint {
  final AddPaymentMethodInput input;

  AddPaymentMethodEndpoint(this.input);

  @override
  String get route => ApiRoutes.paymentMethods;

  @override
  HttpMethod get httpMethod => HttpMethod.post;

  @override
  Map<String, dynamic>? get body => input.toJson();
}


class AddPaymentMethodInput {
  final String label;
  final String value;
  final bool? isDefault;
  final String type;
  final String cardBrandId;

  AddPaymentMethodInput({
    required this.label,
    required this.value,
    this.isDefault,
    required this.type,
    required this.cardBrandId,
  });

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
    "default": isDefault,
    "type": type,
    "cardBrandId": cardBrandId,
  };
}