class ApiRoutes {

  static const String baseUrl = 'https://unsub.eminaliyev.com/api';


  static const String login = '$baseUrl/auth/sign-in';
  static const String register = '$baseUrl/auth/sign-up';
  static const String refreshToken = '$baseUrl/auth/refresh';
  static const String me = '$baseUrl/auth/me';


  //payment methods
  static const String cardBrands = '$baseUrl/payment-methods/card-brands';
  static const String paymentMethods = '$baseUrl/payment-methods';
  static const String types = '$baseUrl/payment-methods/types';
  static const String paymentMethodById = '$baseUrl/payment-methods';


  //services
  static const String services = '$baseUrl/services';

  //categories
  static const String categories = '$baseUrl/categories';

  //currencies
  static const String currencies = '$baseUrl/currencies';

  //subscriptions
  static const String subscriptions = '$baseUrl/subscriptions';
  }
