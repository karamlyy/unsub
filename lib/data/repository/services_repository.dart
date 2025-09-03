import 'package:dartz/dartz.dart';
import 'package:unsub/data/endpoint/category/categories_endpoint.dart';
import 'package:unsub/data/endpoint/service/services_endpoint.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/model/service/categories_model.dart';
import 'package:unsub/data/model/service/services_model.dart';
import 'package:unsub/data/service/api/api.dart';

abstract class ServicesRepository {
  Future<Either<HttpException, ServicesModel>> getServices();
  Future<Either<HttpException, CategoriesModel>> getCategories();
}

class ServicesRepositoryImpl extends ServicesRepository {
  final ApiService apiService;
  ServicesRepositoryImpl(this.apiService);

  @override
  Future<Either<HttpException, ServicesModel>> getServices() async {
    return await apiService.task<ServicesModel>(ServicesEndpoint());
  }

  @override
  Future<Either<HttpException, CategoriesModel>> getCategories() async {
    return await apiService.task<CategoriesModel>(CategoriesEndpoint());
  }
}
