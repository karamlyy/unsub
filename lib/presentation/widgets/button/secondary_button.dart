import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isDisabled;
  final String iconAsset;

  const SecondaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isDisabled = false,
    this.iconAsset = "",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: UIColor.transparent,
          foregroundColor: UIColor.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: UIColor.border, width: 1),
          ),
          elevation: 0,
        ),
        onPressed: isDisabled ? null : onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (iconAsset.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 0.w),
                  child: SvgPicture.asset(iconAsset, width: 24.w, height: 24.h),
                ),
              ),

            // Always centered text
            PrimaryText(title),
          ],
        ),
      ),
    );
  }
}
