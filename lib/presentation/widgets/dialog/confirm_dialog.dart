import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

Future<bool> showPlatformConfirmDialog(
    BuildContext context, {
      required String title,
      required String message,
      String confirmText = 'OK',
      String cancelText = 'Cancel',
      bool isDestructive = false,
      Color? confirmColor,
      Color? cancelColor,
    }) async {
  final Color effectiveConfirmColor = confirmColor ?? (isDestructive ? UIColor.error : UIColor.primary);
  final Color effectiveCancelColor = cancelColor ?? UIColor.textPrimary;

  if (Platform.isIOS) {
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: PrimaryText(
          title,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: PrimaryText(
          message,
          fontSize: 14,
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigation.pop(false),
            child: PrimaryText(cancelText, color: effectiveCancelColor),
          ),
          CupertinoDialogAction(
            isDestructiveAction: isDestructive,
            onPressed: () => Navigation.pop(true),
            child: PrimaryText(confirmText, color: effectiveConfirmColor),
          ),
        ],
      ),
    ) ??
        false;
  } else {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: PrimaryText(
          title,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: PrimaryText(
          message,
          fontSize: 14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigation.pop(false),
            child: PrimaryText(cancelText, color: effectiveCancelColor),
          ),
          TextButton(
            onPressed: () => Navigation.pop(true),
            child: PrimaryText(confirmText, color: effectiveConfirmColor),
          ),
        ],
      ),
    ) ??
        false;
  }
}

Future<bool> showDeleteConfirmDialog(BuildContext context) {
  return showPlatformConfirmDialog(
    context,
    title: 'Delete?',
    message: 'Remove this subscription?',
    confirmText: 'Delete',
    cancelText: 'Cancel',
    isDestructive: true,
    confirmColor: UIColor.error,
  );
}