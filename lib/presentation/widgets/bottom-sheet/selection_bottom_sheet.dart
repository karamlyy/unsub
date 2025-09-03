import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class SelectionBottomSheet {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<String> options,
    String? selected,
    required void Function(String) onSelected,
  }) async {
    await showModalBottomSheet(
      context: context,
      sheetAnimationStyle: const AnimationStyle(
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        reverseCurve: Curves.easeOut,
        reverseDuration: Duration(milliseconds: 500),
      ),
      barrierColor: UIColor.primary.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              8.verticalSpace,
              Center(
                child: Container(
                  width: 48.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: UIColor.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: PrimaryText(title, fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 8.h),
              ...options.map(
                (e) => ListTile(
                  title: PrimaryText(e, fontSize: 16, color: Colors.black),
                  selected: e == selected,
                  onTap: () {
                    Navigation.pop();
                    onSelected(e);
                  },
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
