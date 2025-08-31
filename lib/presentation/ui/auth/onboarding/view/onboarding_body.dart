import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:unsub/config/router.dart';
import 'package:unsub/presentation/navigation/app_router.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/widgets/button/secondary_button.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class OnboardingBody extends StatelessWidget {
  const OnboardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Image.asset("assets/images/onboarding.png"),
          24.verticalSpace,
          PrimaryText(
            "My Subscriptions",
            fontWeight: FontWeight.w700,
            fontSize: 34.sp,
            letterSpacing: -2.4,
            textAlign: TextAlign.center,
          ),
          8.verticalSpace,
          PrimaryText(
            "all your subscriptions in one app",
            color: UIColor.textSecondary.withValues(alpha: 0.6),
            textAlign: TextAlign.center,
          ),
          Spacer(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SecondaryButton(
              title: "Login",
              onPressed: () {
                Navigation.push(Routes.login);
              },
            ),
          ),
          16.verticalSpace,
        ],
      ),
    );
  }
}
