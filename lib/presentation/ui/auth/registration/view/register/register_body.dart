import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/auth/registration/provider/register_provider.dart';
import 'package:unsub/presentation/widgets/button/primary_button.dart';
import 'package:unsub/presentation/widgets/text-field/primary_textfield.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterProvider>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        child: Column(
          children: [
            PrimaryText(
              "New Profile",
              fontWeight: FontWeight.w700,
              fontSize: 28.sp,
              letterSpacing: -2.4,
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            PrimaryText(
              "How can we contact you?",
              color: UIColor.textSecondary.withValues(alpha: 0.6),
              textAlign: TextAlign.center,
            ),
            32.verticalSpace,
            PrimaryTextFormField(
              hintText: "username",
              keyboardType: TextInputType.name,
              onChanged: provider.updateUsername,
            ),
            12.verticalSpace,
            PrimaryTextFormField(
              hintText: "password",
              obscureText: true,
              onChanged: provider.updatePassword,
            ),
            12.verticalSpace,
            PrimaryTextFormField(
              hintText: "confirm password",
              obscureText: true,
              onChanged: provider.updateConfirmPassword,
            ),
            Spacer(),
            PrimaryButton(
              title: "Next",
              onPressed: () => context.goNamed('select-subscriptions'),
              isDisabled: !provider.isFormValid,
            ),
          ],
        ),
      ),
    );
  }
}
