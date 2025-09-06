import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:unsub/app/cubit/app_cubit.dart';
import 'package:unsub/app/cubit/app_state.dart';
import 'package:unsub/app/generic/generic_state.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/auth/login/view/login_page.dart';
import 'package:unsub/presentation/ui/auth/onboarding/view/onboarding_page.dart';
import 'package:unsub/presentation/ui/home/view/home_page.dart';

import '../../presentation/navigation/route_generator.dart' as RouteGenerator;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ , child) {
        return MaterialApp(
          navigatorKey: Navigation.navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RouteGenerator.generateRoute,
          title: 'UnSub',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            primaryColor: UIColor.primary,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
            ),
          ),
          home: Consumer<AppProvider>(
            builder: (context, provider, _) {
              final state = provider.state;
              return page(state, context);
            },
          ),

        );
      },
    );
  }
}


page(GenericState state, BuildContext context) {
  if (state is Authorized) {
    return const HomePage();
  } else if (state is Unauthorized) {
    return const LoginPage();
  } else if (state is Onboarding) {
    return const OnboardingPage();
  }
  return const OnboardingPage();
}
