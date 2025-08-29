import 'package:flutter/material.dart';
import 'package:unsub/presentation/navigation/app_router.dart';
import 'package:unsub/presentation/ui/auth/login/view/login_page.dart';
import 'package:unsub/presentation/ui/auth/onboarding/view/onboarding_page.dart';
import 'package:unsub/presentation/ui/auth/registration/view/register/register_page.dart';

Route<dynamic> createPageRoute(Widget page, [RouteSettings? settings]) {
  return MaterialPageRoute(
    builder: (_) => page,
    settings: settings,
  );
}

Route<dynamic> generateRoute(RouteSettings settings) {
  final routeName = Routes.fromString(settings.name);
  switch (routeName) {
    case Routes.onboarding:
      return createPageRoute(const OnboardingPage(), settings);
    case Routes.login:
      return createPageRoute(const LoginPage(), settings);
    case Routes.register:
      return createPageRoute(const RegisterPage(), settings);
    default:
      return createPageRoute(
        const Scaffold(
          body: Center(child: Text('No route defined')),
        ),
        settings,
      );
  }
}