// home_body.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // ➜ add this
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
    final items = provider.subscriptions;
    final isLoading = (provider as dynamic).isLoading == true; // assumes you expose isLoading

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PrimaryText(
              "My subscriptions",
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
            16.verticalSpace,

            // ===== Summary card / skeleton =====
            if (isLoading)
              const _SummarySkeleton()
            else
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: UIColor.textfieldBackground,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PrimaryText(
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

            // ===== List / skeleton =====
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
                      child: const PrimaryText(
                        "Active subscriptions",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    4.verticalSpace,

                    if (isLoading)
                      const Expanded(child: _ListSkeleton(itemCount: 6))
                    else if (items.isEmpty)
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
                                String label = sub.service?.label ?? sub.customLabel;
                                return await showPlatformConfirmDialog(
                                  context,
                                  title: 'Delete?',
                                  message: 'Remove $label subscription?',
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
                                  child: Image.network(
                                    sub.service?.logo ?? sub.customLogo,
                                    fit: BoxFit.cover,
                                    width: 44.w,
                                    height: 44.w,
                                  ),
                                ),
                                title: PrimaryText(
                                  sub.service?.label ?? sub.customLabel,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: UIColor.textPrimary,
                                ),
                                subtitle: PrimaryText(
                                  sub.paymentMethod?.label ?? "",
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
                                        sub.nextPaymentDate ?? DateTime.now(),
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

/// ===== Reusable shimmer pieces =====

class _SummarySkeleton extends StatelessWidget {
  const _SummarySkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: UIColor.textfieldBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBar(width: 180.w, height: 18.h, radius: 6.r),
          12.verticalSpace,
          Row(
            children: [
              _ShimmerCircle(size: 40.w),
              10.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBar(width: 90.w, height: 16.h, radius: 6.r),
                  6.verticalSpace,
                  _ShimmerBar(width: 140.w, height: 12.h, radius: 6.r),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  final int itemCount;
  const _ListSkeleton({this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
      separatorBuilder: (_, __) => 4.verticalSpace,
      itemBuilder: (_, __) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            children: [
              _ShimmerCircle(size: 44.w),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBar(width: double.infinity, height: 16.h, radius: 6.r),
                    6.verticalSpace,
                    _ShimmerBar(width: 120.w, height: 12.h, radius: 6.r),
                  ],
                ),
              ),
              12.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ShimmerBar(width: 48.w, height: 16.h, radius: 6.r),
                  6.verticalSpace,
                  _ShimmerBar(width: 64.w, height: 12.h, radius: 6.r),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerBar extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const _ShimmerBar({required this.width, required this.height, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: UIColor.grayDark.withValues(alpha: 0.35),
      highlightColor: Colors.white.withValues(alpha: 0.15),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: UIColor.grayDark,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class _ShimmerCircle extends StatelessWidget {
  final double size;
  const _ShimmerCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: UIColor.grayDark.withValues(alpha: 0.35),
      highlightColor: Colors.white.withValues(alpha: 0.15),
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: UIColor.grayDark,
        ),
      ),
    );
  }
}