import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorState({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: UIColor.error),
          8.verticalSpace,
          const PrimaryText('Error'),
          4.verticalSpace,
          PrimaryText(message),
          8.verticalSpace,
          TextButton(onPressed: onRetry, child: const PrimaryText('Retry')),
        ],
      ),
    );
  }
}