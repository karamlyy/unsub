enum Routes {
  onboarding( 'onboarding'),
  login( 'login'),
  register( 'register');


  const Routes( this.path);

  final String path;


  static Routes? fromString(String? route){
    return Routes.values.firstWhere((element) => element.path == route);
  }
}