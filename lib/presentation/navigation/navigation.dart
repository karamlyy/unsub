import 'package:flutter/material.dart';
import 'package:unsub/presentation/navigation/app_router.dart';
import 'package:unsub/presentation/navigation/route_generator.dart';

class Navigation {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future push(Routes route, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(route.path, arguments: arguments);
  }


  static pushReplacementNamed(Routes route, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(route.path, arguments: arguments);
  }

  static pushReplacement(Widget widget) {
    return navigatorKey.currentState!.pushReplacement(createPageRoute(widget));
  }

  static pushNamedAndRemoveUntil(Routes route, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      route.path,
          (route) => false,
      arguments: arguments,
    );
  }

  static pushAndRemoveUntil(Widget widget) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      createPageRoute(widget),
          (route) => false,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState!.pop(result);
  }

  static void popUntil(Routes route) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(route.path));
  }
}