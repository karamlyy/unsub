import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/widgets/button/primary_button.dart';


class PrimaryBottomSheet {
  static show(
      context, {
        String? text,
        VoidCallback? didTap,
        List<PrimaryButton>? buttons,
        bool isDismissible = true,
        Widget? child,
      }) async {
    return await showModalBottomSheet(
      context: context,
      barrierColor: UIColor.textPrimary.withValues(alpha: 0.3),
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.fastEaseInToSlowEaseOut,
        reverseDuration: const Duration(milliseconds: 300),
        duration: const Duration(milliseconds: 500),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      isDismissible: isDismissible,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (text != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        splashRadius: 22,
                        onPressed: didTap ?? () => context.pop(),
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  if (text != null)
                    Text(
                      text,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  10.verticalSpace,
                  child ?? const SizedBox.shrink(),
                  if (buttons != null)
                    for (var i in buttons) ...[
                      i,
                      8.verticalSpace,
                    ],
                  32.verticalSpace,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}