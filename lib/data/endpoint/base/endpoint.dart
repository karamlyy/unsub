import 'package:dio/dio.dart';

enum HttpMethod{
  get("GET"),
  post("POST"),
  put("PUT"),
  delete("DELETE");

  final String name;
  const HttpMethod(this.name);
}

enum ApiType{
  internal,
  external,
}

abstract class Endpoint{
  HttpMethod httpMethod = HttpMethod.get;
  ApiType apiType = ApiType.internal;
  late String route;
  Map<String, dynamic>? body;
  String? externalBody;
  Map<String,dynamic>? queryParameters = {};
  CancelToken? cancelToken;
}