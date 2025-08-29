import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/data/model/subscription_model.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/add-subscription/provider/add_subscription_provider.dart';
import 'package:unsub/presentation/widgets/button/primary_button.dart';
import 'package:unsub/presentation/widgets/text-field/primary_textfield.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class AddSubscriptionBody extends StatelessWidget {
  const AddSubscriptionBody({super.key});

  String _labelOf(SubscriptionCategory category) {
    return category.name;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddSubscriptionProvider>();
    final items = provider.subscriptions;
    final selected = provider.selectedCategory;

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
                color: Colors.white70,
                size: 20,
              ),
              onChanged: provider.updateQuery,
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
                    // Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: PrimaryText(
                        "Popular subscriptions",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    8.verticalSpace,
                    SizedBox(
                      height: 40.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: ChoiceChip(
                              label: PrimaryText("all", fontSize: 13),
                              selected: selected == null,
                              onSelected: (_) => provider.setCategory(null),
                              selectedColor: UIColor.primary,
                              labelStyle: TextStyle(
                                color: selected == null
                                    ? UIColor.primary
                                    : UIColor.textPrimary,
                              ),
                              backgroundColor: Colors.black26,
                              side: BorderSide.none,
                            ),
                          ),
                          ...SubscriptionCategory.values.map((c) {
                            final isSel = selected == c;
                            return Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: ChoiceChip(
                                label: PrimaryText(_labelOf(c), fontSize: 13),
                                selected: isSel,
                                onSelected: (_) => provider.setCategory(c),
                                selectedColor: UIColor.primary,
                                labelStyle: TextStyle(
                                  color: isSel ? UIColor.primary : UIColor.textPrimary,
                                ),
                                backgroundColor: Colors.black26,
                                side: BorderSide.none,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    4.verticalSpace,
                    Expanded(
                      child: items.isEmpty
                          ? Center(
                              child: PrimaryText(
                                "No results",
                                color: UIColor.textSecondary.withValues(
                                  alpha: .7,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final sub = items[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 4.h,
                                  ),
                                  leading: ClipOval(
                                    child: Image.asset(
                                      sub.logoAsset,
                                      fit: BoxFit.cover,
                                      width: 44.w,
                                      height: 44.w,
                                    ),
                                  ),
                                  title: PrimaryText(
                                    sub.title,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: UIColor.textPrimary,
                                  ),
                                  trailing: sub.isSelected
                                      ? const Icon(
                                          CupertinoIcons.checkmark_circle_fill,
                                          color: UIColor.primary,
                                        )
                                      : null,
                                  onTap: () =>
                                      context.goNamed("selected-subscription"),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            16.verticalSpace,
            PrimaryButton(title: "Next", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
