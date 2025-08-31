import 'package:unsub/data/endpoint/base/endpoint.dart';
import 'package:unsub/presentation/utils/api_routes.dart';

class RegisterEndpoint extends Endpoint {
  final RegisterInput input;

  RegisterEndpoint(this.input);

  @override
  String get route => ApiRoutes.register;

  @override
  HttpMethod get httpMethod => HttpMethod.post;

  @override
  Map<String, dynamic>? get body => input.toJson();
}

class RegisterInput {
  final String username;
  final String password;
  final bool autoSignIn;

  RegisterInput({required this.username, required this.password, required this.autoSignIn});

  Map<String, dynamic> toJson() => {
    "body": {"username": username, "password": password, "autoSignIn": autoSignIn},
  };
}


