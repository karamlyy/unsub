enum Routes {
  onboarding( 'onboarding'),
  login( 'login'),
  register( 'register'),
  home( 'home'),
  profile( 'profile'),
  instructions( 'instructions'),
  addSubscription('add-subscription'),
  payment('payment'),
  none( 'none');





  const Routes(this.route);

  final String route;

  static Routes? fromString(String? route) {
    return Routes.values.firstWhere((element) => element.route == route);
  }
}
