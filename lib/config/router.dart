import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unsub/presentation/ui/auth/login/view/login_page.dart';
import 'package:unsub/presentation/ui/auth/onboarding/view/onboarding_page.dart';
import 'package:unsub/presentation/ui/auth/register/view/register_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingPage();
      },
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterPage();
      },
    ),
  ],
);

class RouteNames {
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';
}
