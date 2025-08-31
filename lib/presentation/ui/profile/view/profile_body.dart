import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/profile/provider/profile_provider.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';
import 'package:unsub/presentation/widgets/indicator/loading_indicator.dart';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (provider.isLoading)
              const LoadingIndicator(),
            if (provider.errorMessage != null && !provider.isLoading)
              PrimaryText(provider.errorMessage!, color: UIColor.error),
            if (!provider.isLoading) ...[
            CircleAvatar(
              radius: 34.r,
              backgroundColor: UIColor.grayDark.withValues(alpha: .25),
              child: PrimaryText(
                provider.username.isNotEmpty ? provider.username.toUpperCase()[0] : "U",
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
            SizedBox(width: double.infinity,),
            const Spacer(),
            ],
          ],
        ),
      ),
    );
  }
}
