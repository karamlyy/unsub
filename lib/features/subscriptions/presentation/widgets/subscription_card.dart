import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unsub/features/subscriptions/presentation/widgets/edit_subscription_sheet.dart';
import 'package:unsub/features/ai/presentation/widgets/cancel_help_sheet.dart';
import '../../data/models/subscription_model.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key, required this.subscription});

  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surface = theme.colorScheme.surface;
    final borderColor = isDark
        ? const Color(0xFF111827)
        : const Color(0xFFE5E7EB);
    final titleColor = theme.textTheme.bodyMedium?.color ?? Colors.white;
    final subtitleColor = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);
    const accent = Color(0xFF22C55E);
    const warning = Color(0xFFF97316);

    final isActive = subscription.isActive;
    final nextDate = subscription.nextPaymentDate
        .toLocal()
        .toString()
        .split(' ')
        .first;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => EditSubscriptionSheet(subscription: subscription),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: isDark ? const Color(0x66000000) : const Color(0x1A000000),
              blurRadius: 20,
              spreadRadius: -6,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _AvatarCircle(
              label: subscription.name.isNotEmpty
                  ? subscription.name[0].toUpperCase()
                  : '?',
              color: isActive ? accent : warning,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription.name,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),
                  Text(
                    '${subscription.price.toStringAsFixed(2)} ${subscription.currency}',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Növbəti ödəniş: $nextDate',
                    style: TextStyle(color: subtitleColor, fontSize: 11),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => buildCancelHelpSheet(ctx, subscription.name),
                );
              },
              icon: Icon(CupertinoIcons.sparkles, size: 18, color: warning),
              tooltip: 'Ləğv etməyə kömək et (AI)',
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
