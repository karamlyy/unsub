import 'package:get_it/get_it.dart';
import 'package:unsub/data/repository/auth_repository.dart';
import 'package:unsub/data/repository/currencies_repository.dart';
import 'package:unsub/data/repository/payment_methods_repository.dart';
import 'package:unsub/data/repository/services_repository.dart';
import 'package:unsub/data/repository/subscriptions_repository.dart';
import 'package:unsub/data/service/api/api.dart';

GetIt locator = GetIt.instance;

class Injector {
  static register() async {
    await _registerRepositories();
    await _registerComponents();
    await _registerServices();
  }

  static _registerServices() {
    locator.registerSingleton<ApiService>(ApiService());
    //locator.registerSingleton<UIRefreshController>(UIRefreshController());
  }

  static _registerComponents() {

  }

  static _registerRepositories() {
    locator.registerFactory<AuthRepository>(() => AuthRepositoryImpl(locator.get()));
    locator.registerFactory<PaymentMethodsRepository>(() => PaymentMethodsRepositoryImpl(locator.get()));
    locator.registerFactory<ServicesRepository>(() => ServicesRepositoryImpl(locator.get()));
    locator.registerFactory<CurrenciesRepository>(() => CurrenciesRepositoryImpl(locator.get()));
    locator.registerFactory<SubscriptionsRepository>(() => SubscriptionsRepositoryImpl(locator.get()));
  }
}
