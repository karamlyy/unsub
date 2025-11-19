import 'package:flutter/material.dart';
import 'package:unsub/features/subscriptions/presentation/widgets/edit_subscription_sheet.dart';
import 'package:unsub/features/ai/presentation/widgets/cancel_help_sheet.dart';
import '../../data/models/subscription_model.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key, required this.subscription});

  final SubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF020617);
    const border = Color(0xFF111827);
    const titleColor = Color(0xFFF9FAFB);
    const subtitleColor = Color(0xFF9CA3AF);
    const accent = Color(0xFF22C55E);
    const warning = Color(0xFFF97316);

    final isActive = subscription.isActive;
    final billingCycleLabel = _billingCycleText(subscription.billingCycle);
    final nextDate =
        subscription.nextPaymentDate.toLocal().toString().split(' ').first;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        // Tap → edit bottom sheet
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => EditSubscriptionSheet(
            subscription: subscription,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: surface.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 20,
              spreadRadius: -6,
              offset: Offset(0, 14),
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
                  // üst sətir: ad + status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          subscription.name,
                          style: const TextStyle(
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(isActive: isActive),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // alt xətt: category + billing cycle
                  Row(
                    children: [
                      if (subscription.category != null &&
                          subscription.category!.isNotEmpty)
                        Text(
                          subscription.category!,
                          style: const TextStyle(
                            color: subtitleColor,
                            fontSize: 11,
                          ),
                        ),
                      if (subscription.category != null &&
                          subscription.category!.isNotEmpty)
                        const Text(
                          ' • ',
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 11,
                          ),
                        ),
                      Text(
                        billingCycleLabel,
                        style: const TextStyle(
                          color: subtitleColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // alt info: next payment
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: subtitleColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Növbəti ödəniş: $nextDate',
                        style: const TextStyle(
                          color: subtitleColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // sağda: qiymət + AI info icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${subscription.price.toStringAsFixed(2)} ${subscription.currency}',
                  style: const TextStyle(
                    color: titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  billingCycleShort(subscription.billingCycle),
                  style: const TextStyle(
                    color: subtitleColor,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => buildCancelHelpSheet(
                        ctx,
                        subscription.name,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: subtitleColor,
                  ),
                  tooltip: 'Ləğv etməyə kömək et (AI)',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _billingCycleText(String value) {
    switch (value.toUpperCase()) {
      case 'DAILY':
        return 'Gündəlik';
      case 'WEEKLY':
        return 'Həftəlik';
      case 'MONTHLY':
        return 'Aylıq';
      case 'YEARLY':
        return 'İllik';
      default:
        return value;
    }
  }

  String billingCycleShort(String value) {
    switch (value.toUpperCase()) {
      case 'DAILY':
        return 'günlük';
      case 'WEEKLY':
        return 'həftəlik';
      case 'MONTHLY':
        return 'aylıq';
      case 'YEARLY':
        return 'illik';
      default:
        return value.toLowerCase();
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    const activeBg = Color(0xFF022C22);
    const activeText = Color(0xFF6EE7B7);
    const inactiveBg = Color(0xFF1F2937);
    const inactiveText = Color(0xFFF97373);

    final bg = isActive ? activeBg : inactiveBg;
    final text = isActive ? 'ACTIVE' : 'PAUSED';
    final color = isActive ? activeText : inactiveText;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 0.7,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            color,
            color.withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
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