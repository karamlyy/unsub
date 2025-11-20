import 'package:flutter/material.dart';

class ThemeHelper {
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color sheetBackground(BuildContext context) {
    return isDark(context) ? const Color(0xFF020617) : const Color(0xFFF8F9FA);
  }

  static Color handleColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF4B5563) : const Color(0xFF9CA3AF);
  }

  static Color titleColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
  }

  static Color subtitleColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  }

  static Color borderColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB);
  }

  static Color inputFillColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF020617) : const Color(0xFFF3F4F6);
  }

  static Color dropdownColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF020617) : const Color(0xFFFFFFFF);
  }

  static Color overlayColor(BuildContext context) {
    return Colors.black.withOpacity(isDark(context) ? 0.4 : 0.3);
  }

  static ColorScheme datePickerColorScheme(BuildContext context) {
    return isDark(context)
        ? const ColorScheme.dark(
            primary: Color(0xFF22C55E),
            surface: Color(0xFF020617),
            background: Color(0xFF020617),
          )
        : const ColorScheme.light(
            primary: Color(0xFF22C55E),
            surface: Color(0xFFFFFFFF),
            background: Color(0xFFF8F9FA),
          );
  }

  static Color dialogBackground(BuildContext context) {
    return isDark(context) ? const Color(0xFF020617) : const Color(0xFFFFFFFF);
  }
}
