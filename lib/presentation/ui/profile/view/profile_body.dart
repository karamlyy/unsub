import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unsub/presentation/navigation/app_router.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/profile/provider/profile_provider.dart';
import 'package:unsub/presentation/widgets/button/secondary_button.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (provider.isLoading) const _ProfileSkeleton(),
            if (provider.errorMessage != null && !provider.isLoading)
              PrimaryText(provider.errorMessage!, color: UIColor.error),
            if (!provider.isLoading) ...[
              CircleAvatar(
                radius: 34.r,
                backgroundColor: UIColor.grayDark.withValues(alpha: .25),
                child: PrimaryText(
                  provider.username.isNotEmpty
                      ? provider.username.toUpperCase()[0]
                      : "U",
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              24.verticalSpace,
              PrimaryText(
                '@${provider.username}',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.4,
                color: UIColor.textSecondary.withValues(alpha: 0.6),
              ),
              16.verticalSpace,
              SecondaryButton(
                title: "template payment methods",
                onPressed: () => Navigation.push(Routes.payment),
              ),
              Spacer(),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.white.withValues(alpha: 0.06),
          highlightColor: Colors.white.withValues(alpha: 0.12),
          child: Container(
            width: 68.r,
            height: 68.r,
            decoration: const BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
            ),
          ),
        ),
        24.verticalSpace,
        Shimmer.fromColors(
          baseColor: Colors.white.withValues(alpha: 0.06),
          highlightColor: Colors.white.withValues(alpha: 0.12),
          child: Container(
            width: 160.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        16.verticalSpace,
        Shimmer.fromColors(
          baseColor: Colors.white.withValues(alpha: 0.06),
          highlightColor: Colors.white.withValues(alpha: 0.12),
          child: Container(
            width: 220.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        40.verticalSpace,
      ],
    );
  }
}
