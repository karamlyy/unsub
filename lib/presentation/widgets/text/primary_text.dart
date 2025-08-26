import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;

  const PrimaryText(
      this.text, {
        super.key,
        this.fontSize = 16,
        this.fontWeight = FontWeight.w500,
        this.color = Colors.white,
        this.textAlign = TextAlign.start,
        this.maxLines,
        this.overflow,
        this.letterSpacing,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: "SFPro-Text",
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      ),
    );
  }
}