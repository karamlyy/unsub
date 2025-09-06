import 'package:dartz/dartz.dart';
import 'package:unsub/data/endpoint/subscription/subscriptions_endpoint.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/model/subscription/subscriptions_model.dart';
import 'package:unsub/data/service/api/api.dart';

abstract class SubscriptionsRepository {
  Future<Either<HttpException, SubscriptionsModel>> getSubscriptions();
}

class SubscriptionsRepositoryImpl extends SubscriptionsRepository {
  final ApiService apiService;
  SubscriptionsRepositoryImpl(this.apiService);

  @override
  Future<Either<HttpException, SubscriptionsModel>> getSubscriptions() async {
    return await apiService.task<SubscriptionsModel>(SubscriptionsEndpoint());
  }
}
