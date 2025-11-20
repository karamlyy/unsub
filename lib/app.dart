import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsub/features/subscriptions/presentation/cubit/subscriptions_cubit.dart';
import 'router/app_router.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';

class UnsubApp extends StatelessWidget {
  const UnsubApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'UnSub',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeState.themeMode,
          navigatorKey: rootNavigatorKey,
          onGenerateRoute: router.onGenerateRoute,
          initialRoute: '/login',
          builder: (context, child) {
            return BlocListener<AuthCubit, AuthState>(
              listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
              listener: (context, state) {
                final navigator = rootNavigatorKey.currentState;
                if (navigator == null) return;

                final subsCubit = context.read<SubscriptionsCubit>();

                if (state is Authenticated) {
                  // Yeni user login olduqda köhnə state-dən qurtul
                  subsCubit.reset();

                  navigator.pushNamedAndRemoveUntil(
                    '/subscriptions',
                    (route) => false,
                  );
                } else if (state is Unauthenticated) {
                  // Logout → subs state təmizlə
                  subsCubit.reset();

                  navigator.pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
