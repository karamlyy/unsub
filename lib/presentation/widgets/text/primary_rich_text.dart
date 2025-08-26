import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unsub/presentation/shared/color.dart';

class PrimaryRichText extends StatelessWidget {
  final List<TextSpan> spans;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const PrimaryRichText({
    super.key,
    required this.spans,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
      textAlign: textAlign,
      text: TextSpan(
        style: TextStyle(
          fontFamily: "SFPro-Text",
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: UIColor.textPrimary,

        ),
        children: spans,
      ),
    );
  }
}