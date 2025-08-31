import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/app/cubit/app_cubit.dart';
import 'package:unsub/app/generic/generic_state.dart';
import 'package:unsub/presentation/navigation/app_router.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/auth/login/provider/login_provider.dart';
import 'package:unsub/presentation/widgets/button/primary_button.dart';
import 'package:unsub/presentation/widgets/bottom-sheet/primary_bottom_sheet.dart';
import 'package:unsub/presentation/widgets/text-field/primary_textfield.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        child: Column(
          children: [
            if (provider.state is Success)
              Builder(builder: (context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<AppProvider>().check();
                  Navigation.pushNamedAndRemoveUntil(Routes.home);
                  provider.resetState();
                });
                return const SizedBox.shrink();
              }),
            if (provider.state is Failure)
              Builder(builder: (context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final error = (provider.state as Failure).error.message;
                  PrimaryBottomSheet.show(context, text: error);
                  provider.resetState();
                });
                return const SizedBox.shrink();
              }),
            PrimaryText(
              "Hello there 👋",
              fontWeight: FontWeight.w700,
              fontSize: 28.sp,
              letterSpacing: -2.4,
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            PrimaryText(
              "No surprise renewals.",
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
            Spacer(),
            PrimaryButton(
              title: "Login",
              onPressed: () {
                provider.login();
              },
              isDisabled: !provider.isFormValid,
            ),
            12.verticalSpace,
            GestureDetector(
              onTap: () => Navigation.push(Routes.register),
              child: PrimaryText("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
