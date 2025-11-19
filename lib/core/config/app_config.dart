class AppConfig {
  AppConfig._();

  // iOS simulator üçün:
  // static const String apiBaseUrl = 'http://localhost:3000';
  // static const String apiBaseUrl = 'http://192.168.0.101:3000'; iphone real device üçün
  // Android emulator-da test edəcəksənsə:
  static const String apiBaseUrl = 'http://10.0.2.2:3000';
}

//error handling ucun dartz və endpointlər üçün endpoint classı- yarat. yəni routeları birbaşa belə yazmaq
