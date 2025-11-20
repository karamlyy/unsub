import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsub/features/subscriptions/presentation/widgets/add_subscription_sheet.dart';
import '../cubit/subscriptions_cubit.dart';
import '../widgets/subscription_list.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubscriptionsCubit>();
    final state = cubit.state;
    if (state is SubscriptionsInitial) {
      cubit.loadSubscriptions();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Profil',
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _SubscriptionsBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddSubscriptionSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SubscriptionsBody extends StatelessWidget {
  const _SubscriptionsBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = theme.textTheme.bodyMedium?.color ?? Colors.white;
    final subtitleColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sənin abunəliklərin',
          style: TextStyle(
            color: titleColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Netflix, Spotify, iCloud – hamısı bir yerdə.',
          style: TextStyle(color: subtitleColor, fontSize: 13),
        ),
        const SizedBox(height: 16),
        const Expanded(child: SubscriptionList()),
      ],
    );
  }
}
