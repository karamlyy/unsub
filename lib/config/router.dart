import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unsub/presentation/ui/add-subscription/view/add_subscription_page.dart';
import 'package:unsub/presentation/ui/auth/login/view/login_page.dart';
import 'package:unsub/presentation/ui/auth/onboarding/view/onboarding_page.dart';
import 'package:unsub/presentation/ui/auth/registration/provider/select_subscriptions_provider.dart';
import 'package:unsub/presentation/ui/auth/registration/view/register/register_page.dart';
import 'package:unsub/presentation/ui/auth/registration/view/select_subsriptions/select_subscriptions_page.dart';
import 'package:unsub/presentation/ui/auth/registration/view/selected_subscription/selected_subscription_page.dart';
import 'package:unsub/presentation/ui/home/view/home_page.dart';
import 'package:unsub/presentation/ui/instructions/view/instructions_page.dart';
import 'package:unsub/presentation/ui/profile/view/edit_profile_page.dart';
import 'package:unsub/presentation/ui/profile/view/profile_page.dart';
import 'package:unsub/presentation/widgets/navbar/bottom_navbar.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
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
    GoRoute(
      path: '/select-subscriptions',
      name: 'select-subscriptions',
      builder: (BuildContext context, GoRouterState state) {
        return const SelectSubscriptionsPage();
      },
    ),
    GoRoute(
      path: '/selected-subscription',
      name: 'selected-subscription',
      builder: (BuildContext context, GoRouterState state) {
        final selectedSubscriptions = state.extra as List<SubscriptionItem>? ?? [];
        return SelectedSubscriptionPage(
          selectedSubscriptions: selectedSubscriptions,
        );
      },
    ),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavBar(),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: '/intructions',
          name: 'intructions',
          builder: (BuildContext context, GoRouterState state) {
            return const InstructionsPage();
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfilePage();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/edit-profile',
      name: 'edit-profile',
      builder: (BuildContext context, GoRouterState state) {
        return const EditProfilePage();
      },
    ),
    GoRoute(
      path: '/add-subscription',
      name: 'add-subscription',
      builder: (BuildContext context, GoRouterState state) {
        return const AddSubscriptionPage();
      },
    ),
  ],
);

class RouteNames {
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';
  static const String selectSubscriptions = 'select-subscriptions';
  static const String selectedSubscription = 'selected-subscription';
  static const String home = 'home';
  static const String instructions = 'intructions';
  static const String profile = 'profile';
  static const String editProfile = 'edit-profile';
  static const String addSubscription = 'add-subscription';
}
