import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/subscriptions_cubit.dart';
import 'subscription_card.dart';

class SubscriptionList extends StatelessWidget {
  const SubscriptionList({super.key});

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFFE5E7EB);
    const subtitleColor = Color(0xFF6B7280);

    return BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
      builder: (context, state) {
        if (state is SubscriptionsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SubscriptionsFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Color(0xFFF97373)),
                  const SizedBox(height: 8),
                  Text(
                    'Nəsə alınmadı',
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.message,
                    style: const TextStyle(
                      color: subtitleColor,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else if (state is SubscriptionsLoaded) {
          if (state.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.nightlight_round,
                      color: Color(0xFF4B5563),
                      size: 42,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Hələ abunəliyin yoxdur',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '“+” düyməsinə bas və ilk subscription-u əlavə et. Qaranlıqdan xilas ol 😉',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return SubscriptionCard(subscription: item);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}