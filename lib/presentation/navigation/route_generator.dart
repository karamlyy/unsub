import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unsub/presentation/navigation/app_router.dart';
import 'package:unsub/presentation/ui/add-subscription/view/add_subscription_detail_page.dart';
import 'package:unsub/presentation/ui/add-subscription/view/add_subscription_page.dart';
import 'package:unsub/presentation/ui/auth/login/view/login_page.dart';
import 'package:unsub/presentation/ui/auth/onboarding/view/onboarding_page.dart';
import 'package:unsub/presentation/ui/auth/registration/view/register/register_page.dart';
import 'package:unsub/presentation/ui/home/view/home_page.dart';
import 'package:unsub/presentation/ui/instructions/view/instructions_page.dart';
import 'package:unsub/presentation/ui/payment/view/add_payment_page.dart';
import 'package:unsub/presentation/ui/payment/view/payment_page.dart';
import 'package:unsub/presentation/ui/profile/view/profile_page.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

Route<dynamic> createPageRoute(Widget page, [RouteSettings? settings]) {
  return MaterialPageRoute(builder: (_) => page, settings: settings);
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
    case Routes.home:
      return createPageRoute(const HomePage(), settings);
    case Routes.instructions:
      return createPageRoute(const InstructionsPage(), settings);
    case Routes.profile:
      return createPageRoute(const ProfilePage(), settings);
    case Routes.addSubscription:
      return createPageRoute(const AddSubscriptionPage(), settings);
    case Routes.addSubscriptionDetails:
      return createPageRoute(AddSubscriptionDetailPage(arguments: settings.arguments as Map<String, dynamic>?), settings);
    case Routes.payment:
      return createPageRoute(const PaymentPage(), settings);
    case Routes.addPayment:
      return createPageRoute(const AddPaymentPage(), settings);
    default:
      return createPageRoute(
        const Scaffold(body: Center(child: Text('No route defined'))),
        settings,
      );
  }
}

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final route = Routes.fromString(settings.name);
    final args = settings.arguments;

    if (kDebugMode) {
      print("Navigating to :> [$route] ; Arguments are :> [$args]");
    }

    switch (route) {
      case Routes.home:
        return _push(const HomePage());
      case Routes.login:
        return _push(LoginPage());
      case Routes.register:
        return _push(RegisterPage());
      case Routes.instructions:
        return _push(const InstructionsPage());
      case Routes.profile:
        return _push(const ProfilePage());
      case Routes.addSubscription:
        return _push(AddSubscriptionPage());
      case Routes.addSubscriptionDetails:
        return _push(AddSubscriptionDetailPage(arguments: args as Map<String, dynamic>?));
      case Routes.payment:
        return _push(const PaymentPage());
      case Routes.addPayment:
        return _push(const AddPaymentPage());
      case Routes.none:
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static PageRoute _push(Widget widget) {
    return Platform.isIOS
        ? CupertinoPageRoute(builder: (_) => widget)
        : PageRouteBuilder(
            pageBuilder: (_, __, ___) => widget,
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (_, animation, secondaryAnimation, child) {
              const curve = Curves.easeInOut;
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: curve,
              );

              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              );
            },
          );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.time, size: 30),

              const Center(child: PrimaryText("Coming Soon")),
            ],
          ),
        );
      },
    );
  }
}
