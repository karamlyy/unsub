import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsub/features/subscriptions/presentation/cubit/subscriptions_cubit.dart';
import 'router/app_router.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

class UnsubApp extends StatelessWidget {
  const UnsubApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();

    const background = Color(0xFF050816); // çox tünd navy/black
    const surface = Color(0xFF0B1120); // kartlar üçün
    const primary = Color(0xFF22C55E); // accent (tünd yaşıl)
    const textColor = Color(0xFFE5E7EB); // açıq boz tekst

    final theme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: primary,
        background: background,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      cardColor: surface,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF020617),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1F2937)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1F2937)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.4),
        ),
        labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
      ),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: textColor)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF111827),
        contentTextStyle: TextStyle(color: textColor),
      ),
    );

    return MaterialApp(
      title: 'UnSub',
      debugShowCheckedModeBanner: false,
      theme: theme,
      themeMode: ThemeMode.dark,
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
  }
}
