import 'package:unsub/data/model/auth/login_model.dart';

class ResponseModel<T> {
  T? response;
  int? code;
  String? message;

  ResponseModel({
    this.response,
    this.code,
    this.message,
  });

  factory ResponseModel.fromJson(dynamic json) {
    T? getData(dynamic data) {
      if (data == null) return null;
      if (T == LoginModel) {
        return LoginModel.fromJson(data) as T?;
      }

      return data as T?;
    }

    final isList = json is List;
    final isMap = json is Map;
    final isString = json is String;

    return ResponseModel(
      code: isList || isMap || isString ? null : json["code"],
      message: isList || isMap || isString ? null : json["message"],
      response: getData(json),
    );
  }

  bool get hasData {
    return response != null;
  }

  bool get isUnauthorized {
    return code == 401;
  }
}
