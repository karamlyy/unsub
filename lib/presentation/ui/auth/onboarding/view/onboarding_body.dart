import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:unsub/config/router.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/widgets/button/secondary_button.dart';
import 'package:unsub/presentation/widgets/text/primary_rich_text.dart';
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
                context.goNamed(RouteNames.login);
              },
            ),
          ),
          12.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SecondaryButton(
              title: "Continue with Apple",
              onPressed: () {},
              iconAsset: "assets/icons/apple_logo.svg",
            ),
          ),
          12.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SecondaryButton(
              title: "Continue with Google",
              onPressed: () {},
              iconAsset: "assets/icons/google_logo.svg",
            ),
          ),
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: PrimaryRichText(
              textAlign: TextAlign.center,
              spans: [
                const TextSpan(
                  text: "By signing in, you accept the ",
                  style: TextStyle(
                    color: UIColor.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "user agreements",
                  style: const TextStyle(
                    color: UIColor.textPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const TextSpan(
                  text: " and ",
                  style: TextStyle(
                    color: UIColor.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "privacy policy",
                  style: const TextStyle(
                    color: UIColor.textPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
