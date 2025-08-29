import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/profile/provider/profile_provider.dart';
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 34.r,
              backgroundColor: UIColor.grayDark.withValues(alpha: .25),
              child: PrimaryText("KA"),
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
        ),
      ),
    );
  }
}
