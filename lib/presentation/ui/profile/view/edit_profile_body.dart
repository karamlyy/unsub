import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/profile/provider/edit_profile_provider.dart';
import 'package:unsub/presentation/ui/profile/provider/profile_provider.dart';
import 'package:unsub/presentation/widgets/button/primary_button.dart';
import 'package:unsub/presentation/widgets/text-field/primary_textfield.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class EditProfileBody extends StatelessWidget {
  const EditProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 34.r,
              backgroundColor: UIColor.grayDark.withValues(alpha: .25),
              child: PrimaryText("KA"),
            ),
            24.verticalSpace,
            PrimaryTextFormField(
              hintText: "username",
              onChanged: provider.updateUsername,
              initialValue: provider.username,
            ),
            const Spacer(),
            PrimaryButton(
              title: "Done",
              onPressed: () async {
                await provider.saveProfile();
                context.goNamed("profile");
              },
            ),
          ],
        ),
      ),
    );
  }
}
