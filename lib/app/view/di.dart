import 'package:get_it/get_it.dart';
import 'package:unsub/data/repository/auth_repository.dart';
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
    //locator.registerFactory<ShareManager>(() => ShareManager());
    //locator.registerFactory<DatePickerHelper>(() => DatePickerHelper());
  }

  static _registerRepositories() {
    locator.registerFactory<AuthRepository>(() => AuthRepositoryImpl(locator.get()));
  }
}
