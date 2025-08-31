// home_body.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/navigation/app_router.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/home/provider/home_provider.dart';
import 'package:unsub/presentation/utils/formatter/date_formatter.dart';
import 'package:unsub/presentation/widgets/button/primary_button.dart';
import 'package:unsub/presentation/widgets/dialog/confirm_dialog.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final items = provider.items;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              "My subscriptions",
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
            16.verticalSpace,

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                color: UIColor.textfieldBackground,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    "Average consumption",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: UIColor.grayDark,
                        ),
                        child: SvgPicture.asset("assets/icons/dollar.svg"),
                      ),
                      10.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryText(
                            '${provider.sumOfPrices()}\$',
                            fontSize: 17,
                          ),
                          PrimaryText(
                            "${items.length} active subscriptions",
                            color: UIColor.textSecondary.withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            12.verticalSpace,
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: UIColor.textfieldBackground,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: PrimaryText(
                        "Active subscriptions",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    4.verticalSpace,
                    if (items.isEmpty)
                      Expanded(
                        child: Center(
                          child: PrimaryText(
                            "No subscriptions yet",
                            color: UIColor.textSecondary.withValues(alpha: .7),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final sub = items[index];
                            return Dismissible(
                              key: ValueKey(sub.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                color: UIColor.error,
                                child: const Icon(
                                  CupertinoIcons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                return await showPlatformConfirmDialog(
                                  context,
                                  title: 'Delete?',
                                  message: 'Remove ${sub.name} subscription?',
                                  confirmText: 'Delete',
                                  cancelText: 'Cancel',
                                  isDestructive: true,
                                  confirmColor: UIColor.error,
                                );
                              },
                              onDismissed: (_) => provider.removeAt(index),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 4.h,
                                ),
                                leading: ClipOval(
                                  child: Image.asset(
                                    sub.imageAsset,
                                    fit: BoxFit.cover,
                                    width: 44.w,
                                    height: 44.w,
                                  ),
                                ),
                                title: PrimaryText(
                                  sub.name,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: UIColor.textPrimary,
                                ),
                                subtitle: PrimaryText(
                                  sub.category.name,
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    PrimaryText(
                                      '${sub.price}\$',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: UIColor.textPrimary,
                                    ),
                                    PrimaryText(
                                      AppDateFormatter.monthDay(
                                        sub.nextBilling,
                                      ),
                                      fontSize: 14,
                                      color: provider.isExpiringSoon(sub)
                                          ? UIColor.error
                                          : Colors.white54,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            12.verticalSpace,
            PrimaryButton(
              title: "Add New",
              onPressed: () => Navigation.push(Routes.addSubscription),
            ),
          ],
        ),
      ),
    );
  }
}
