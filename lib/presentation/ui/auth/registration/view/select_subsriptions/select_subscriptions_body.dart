import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/auth/registration/provider/select_subscriptions_provider.dart';
import 'package:unsub/presentation/widgets/button/primary_button.dart';
import 'package:unsub/presentation/widgets/text-field/primary_textfield.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class SelectSubscriptionsBody extends StatelessWidget {
  const SelectSubscriptionsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SelectSubscriptionProvider>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              "Select your active\nsubscriptions",
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
            8.verticalSpace,
            PrimaryTextFormField(
              hintText: "Search",
              prefixIcon: const Icon(CupertinoIcons.search, color: Colors.white70, size: 20),
              onChanged: provider.updateQuery,
            ),
            12.verticalSpace,

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: provider.subscriptions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 14.w,
                  mainAxisSpacing: 18.h,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final sub = provider.subscriptions[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () => provider.toggleSubscription(sub.id),
                    child: Column(
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: sub.isSelected ? UIColor.primary : Colors.transparent,
                              width: sub.isSelected ?  1 : 0,
                            ),

                          ),
                          child: ClipOval(
                            child: Image.asset(
                              sub.logoAsset,
                              fit: BoxFit.contain,
                              width: 56.w,
                              height: 56.w,
                            ),
                          ),
                        ),
                        8.verticalSpace,
                        PrimaryText(
                          sub.title,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: UIColor.textPrimary.withValues(alpha: 0.9),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),


            PrimaryButton(
              title: "Next",
              onPressed: () {
                final selectedSubscriptions = provider.selectedSubscriptions;
                context.goNamed("selected-subscription", extra: selectedSubscriptions);
              },
              isDisabled: !provider.hasAnySelected,
            ),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}