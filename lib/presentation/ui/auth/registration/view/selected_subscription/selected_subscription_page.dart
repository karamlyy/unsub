import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/auth/registration/provider/select_subscriptions_provider.dart';
import 'package:unsub/presentation/ui/auth/registration/provider/selected_subscription_provider.dart';
import 'package:unsub/presentation/ui/auth/registration/view/selected_subscription/selected_subscription_body.dart';


class SelectedSubscriptionPage extends StatelessWidget {
  const SelectedSubscriptionPage({super.key, required this.selectedSubscriptions});
  final List<SubscriptionItem> selectedSubscriptions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: UIColor.transparent,

        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_back, color: UIColor.primary),
          onPressed: () {
            context.goNamed("select-subscriptions");
          },
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => SelectedSubscriptionProvider(),
        child: SelectedSubscriptionBody(selectedSubscription: selectedSubscriptions),
      ),
    );
  }
}