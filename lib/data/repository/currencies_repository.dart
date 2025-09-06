import 'package:dartz/dartz.dart';
import 'package:unsub/data/endpoint/currency/currencies_endpoint.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/model/currency/currencies_model.dart';

import 'package:unsub/data/service/api/api.dart';

abstract class CurrenciesRepository {
  Future<Either<HttpException, CurrenciesModel>> getCurrencies();
}

class CurrenciesRepositoryImpl extends CurrenciesRepository {
  final ApiService apiService;
  CurrenciesRepositoryImpl(this.apiService);

  @override
  Future<Either<HttpException, CurrenciesModel>> getCurrencies() async {
    return await apiService.task<CurrenciesModel>(CurrenciesEndpoint());
  }
}
