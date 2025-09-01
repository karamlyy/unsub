import 'package:dartz/dartz.dart';
import 'package:unsub/data/endpoint/payment/add_payment_method_endpoint.dart';
import 'package:unsub/data/endpoint/payment/card_brands_endpoint.dart';
import 'package:unsub/data/endpoint/payment/delete_payment_method_endpoint.dart';
import 'package:unsub/data/endpoint/payment/get_payment_methods_endpoint.dart';
import 'package:unsub/data/endpoint/payment/types_endpoint.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/model/payment-methods/add_payment_method_model.dart';
import 'package:unsub/data/model/payment-methods/card_brands_model.dart';
import 'package:unsub/data/model/payment-methods/delete_payment_method_model.dart';
import 'package:unsub/data/model/payment-methods/payment_methods_model.dart';
import 'package:unsub/data/model/payment-methods/types_model.dart';
import 'package:unsub/data/service/api/api.dart';


abstract class PaymentMethodsRepository {
  Future<Either<HttpException, CardBrandsModel>> getCardBrands();
  Future<Either<HttpException, TypesModel>> getTypes();
  Future<Either<HttpException, PaymentMethodsModel>> getPaymentMethods();
  Future<Either<HttpException, AddPaymentMethodModel>> addPaymentMethod(AddPaymentMethodInput input);
  Future<Either<HttpException, DeletePaymentMethodModel>> deletePaymentMethod(String input);
}

class PaymentMethodsRepositoryImpl extends PaymentMethodsRepository {
  final ApiService apiService;

  PaymentMethodsRepositoryImpl(this.apiService);

  @override
  Future<Either<HttpException, CardBrandsModel>> getCardBrands() async {
    return await apiService.task<CardBrandsModel>(CardBrandsEndpoint());
  }

  @override
  Future<Either<HttpException, TypesModel>> getTypes() async {
    return await apiService.task<TypesModel>(TypesEndpoint());
  }


  @override
  Future<Either<HttpException, PaymentMethodsModel>> getPaymentMethods() async {
    return await apiService.task<PaymentMethodsModel>(GetPaymentMethodsEndpoint());
  }

  @override
  Future<Either<HttpException, AddPaymentMethodModel>> addPaymentMethod(AddPaymentMethodInput input) async {
    return await apiService.task<AddPaymentMethodModel>(AddPaymentMethodEndpoint(input));
  }


  @override
  Future<Either<HttpException, DeletePaymentMethodModel>> deletePaymentMethod(String input) async {
    return await apiService.task<DeletePaymentMethodModel>(DeletePaymentMethodEndpoint(input));
  }

}
