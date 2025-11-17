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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
    const titleColor = Color(0xFFF9FAFB);
    const subtitleColor = Color(0xFF9CA3AF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sənin abunəliklərin',
          style: TextStyle(
            color: titleColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Netflix, Spotify, iCloud – hamısı bir yerdə.',
          style: TextStyle(color: subtitleColor, fontSize: 13),
        ),
        const SizedBox(height: 16),
        const Expanded(child: SubscriptionList()),
      ],
    );
  }
}
