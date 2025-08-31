import 'package:dartz/dartz.dart';
import 'package:unsub/data/endpoint/payment/card_brands_endpoint.dart';
import 'package:unsub/data/endpoint/payment/get_payment_methods_endpoint.dart';
import 'package:unsub/data/endpoint/payment/types_endpoint.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/model/payment-methods/card_brands_model.dart';
import 'package:unsub/data/model/payment-methods/payment_methods_model.dart';
import 'package:unsub/data/model/payment-methods/types_model.dart';
import 'package:unsub/data/service/api/api.dart';


abstract class PaymentMethodsRepository {
  Future<Either<HttpException, CardBrandsModel>> getCardBrands();
  Future<Either<HttpException, TypesModel>> getTypes();
  Future<Either<HttpException, PaymentMethodsModel>> getPaymentMethods();
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

}
