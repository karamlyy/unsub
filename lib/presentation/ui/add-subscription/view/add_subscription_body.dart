import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unsub/presentation/navigation/app_router.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/add-subscription/provider/add_subscription_provider.dart';
import 'package:unsub/presentation/widgets/button/primary_button.dart';
import 'package:unsub/presentation/widgets/error/error.dart';
import 'package:unsub/presentation/widgets/text-field/primary_textfield.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';
import 'package:unsub/presentation/widgets/tile/service_tile.dart';

class AddSubscriptionBody extends StatelessWidget {
  const AddSubscriptionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddSubscriptionProvider>();
    final filtered = provider.filteredServices;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryTextFormField(
              hintText: "Search",
              prefixIcon: const Icon(
                CupertinoIcons.search,
                color: UIColor.grayLight,
                size: 20,
              ),
              onChanged: (value) => provider.updateSearchQuery(value),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PrimaryText(
                            "Popular subscriptions",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),

                    8.verticalSpace,
                    SizedBox(
                      height: 44.h,
                      child: provider.isLoading
                          ? ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              scrollDirection: Axis.horizontal,
                              itemCount: 6,
                              separatorBuilder: (_, __) => 8.horizontalSpace,
                              itemBuilder: (_, __) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.white.withValues(alpha: 0.06),
                                  highlightColor: Colors.white.withValues(alpha: 0.12),
                                  child: Container(
                                    width: 88.w,
                                    height: 44.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(22.r),
                                    ),
                                  ),
                                );
                              },
                            )
                          : provider.errorMessage != null
                          ? ErrorState(
                              message: provider.errorMessage!,
                              onRetry: () {
                                provider.getCategories();
                                provider.getServices();
                              },
                            )
                          : (provider.categories.isEmpty)
                          ? const Center(
                              child: PrimaryText(
                                'No categories found',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              scrollDirection: Axis.horizontal,
                              itemCount: provider.categories.length + 1,
                              separatorBuilder: (_, __) => 8.horizontalSpace,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  final selected =
                                      provider.selectedCategoryId == null;
                                  return ChoiceChip(
                                    label: const PrimaryText('All'),
                                    selected: selected,
                                    onSelected: (_) =>
                                        provider.selectCategory(null),
                                    selectedColor: UIColor.grayDark.withValues(
                                      alpha: 0.18,
                                    ),
                                    backgroundColor: UIColor.grayDark
                                        .withValues(alpha: 0.08),
                                    labelStyle: TextStyle(
                                      color: selected
                                          ? UIColor.grayDark
                                          : UIColor.grayDark,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color: selected
                                            ? UIColor.grayLight
                                            : UIColor.grayDark,
                                      ),
                                    ),
                                  );
                                }

                                final category = provider.categories[index - 1];
                                final selected =
                                    provider.selectedCategoryId == category.id;
                                return ChoiceChip(
                                  label: PrimaryText(category.label ?? ''),
                                  selected: selected,
                                  onSelected: (v) => provider.selectCategory(
                                    v ? category.id : null,
                                  ),
                                  selectedColor: UIColor.grayDark.withValues(
                                    alpha: 0.18,
                                  ),
                                  backgroundColor: UIColor.grayDark.withValues(
                                    alpha: 0.08,
                                  ),
                                  labelStyle: TextStyle(
                                    color: selected
                                        ? UIColor.grayDark
                                        : UIColor.grayDark,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: selected
                                          ? UIColor.grayDark
                                          : UIColor.grayDark,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    16.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          const PrimaryText(
                            "Services",
                            fontWeight: FontWeight.w600,
                          ),
                          6.horizontalSpace,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: PrimaryText(
                              "${filtered.length}",
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    8.verticalSpace,
                    Expanded(
                      child: provider.isLoading
                          ? ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              itemCount: 8,
                              separatorBuilder: (_, __) => 8.verticalSpace,
                              itemBuilder: (_, __) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.white.withValues(alpha: 0.06),
                                  highlightColor: Colors.white.withValues(alpha: 0.12),
                                  child: _ServiceTileSkeleton(),
                                );
                              },
                            )
                          : filtered.isEmpty
                          ? const Center(
                              child: PrimaryText(
                                'No services found',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => 8.verticalSpace,
                              itemBuilder: (context, index) {
                                final s = filtered[index];
                                return ServiceTile(
                                  title: s.label ?? '',
                                  logoUrl: s.logo ?? '',
                                  onTap: () {
                                    provider.selectService(s);
                                    Navigation.push(
                                      Routes.addSubscriptionDetails,
                                      arguments: {
                                        'selectedService': s.toJson(),
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            16.verticalSpace,
            PrimaryButton(
              title: "Next",
              onPressed: () {
                final selected = provider.selectedService;
                if (selected != null) {
                  Navigation.push(
                    Routes.addSubscriptionDetails,
                    arguments: {'selectedService': selected.toJson()},
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceTileSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 44.w,
                height: 44.w,
                color: Colors.white12,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Container(
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
            12.horizontalSpace,
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
