class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';

  // Subscriptions
  static const String subscriptions = '/subscriptions';
  static String subscriptionById(int id) => '/subscriptions/$id';

  // Users
  static const String me = '/users/me';

  // AI
  static const String smartCancelHelp = '/ai/cancel-help';

  // Categories
  static const String categories = '/categories';
}