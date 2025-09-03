import 'package:unsub/data/model/auth/login_model.dart';
import 'package:unsub/data/model/auth/register_model.dart';
import 'package:unsub/data/model/auth/me_model.dart';
import 'package:unsub/data/model/payment-methods/add_payment_method_model.dart';
import 'package:unsub/data/model/payment-methods/card_brands_model.dart';
import 'package:unsub/data/model/payment-methods/delete_payment_method_model.dart';
import 'package:unsub/data/model/payment-methods/payment_methods_model.dart';
import 'package:unsub/data/model/payment-methods/types_model.dart';
import 'package:unsub/data/model/service/categories_model.dart';
import 'package:unsub/data/model/service/services_model.dart';

class ResponseModel<T> {
  final int? status;
  final String? message;
  final T? response;
  final List<dynamic>? errors;

  bool get hasData => response != null;

  ResponseModel({this.status, this.message, this.response, this.errors});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    T? parseData(dynamic root) {
      final data = (root is Map<String, dynamic> && root["data"] is Map<String, dynamic>)
          ? root["data"] as Map<String, dynamic>
          : (root is Map<String, dynamic> ? root : null);

      if (data == null) return null;

      switch (T) {
        case LoginModel:
          return LoginModel.fromJson(data) as T;
        case RegisterModel:
          return RegisterModel.fromJson(data) as T;
        case MeModel:
          return MeModel.fromJson(data) as T;
        case CardBrandsModel:
          return CardBrandsModel.fromJson(data) as T;
        case TypesModel:
          return TypesModel.fromJson(data) as T;
        case PaymentMethodsModel:
          return PaymentMethodsModel.fromJson(data) as T;
        case AddPaymentMethodModel:
          return AddPaymentMethodModel.fromJson(data) as T;
        case DeletePaymentMethodModel:
          return DeletePaymentMethodModel.fromJson(data) as T;

        case ServicesModel:
          return ServicesModel.fromJson(data) as T;
        case CategoriesModel:
          return CategoriesModel.fromJson(data) as T;
        default:
          return data as T;
      }
    }

    return ResponseModel<T>(
      status: json["status"] is int ? json["status"] as int : null,
      message: json["message"] as String?,
      response: parseData(json),
      errors: (json["errors"] is List) ? json["errors"] as List : null,
    );
  }
}