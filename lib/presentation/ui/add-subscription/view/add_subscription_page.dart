import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/add-subscription/provider/add_subscription_provider.dart';
import 'package:unsub/presentation/ui/add-subscription/view/add_subscription_body.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class AddSubscriptionPage extends StatelessWidget {
  const AddSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIColor.transparent,
        surfaceTintColor: UIColor.transparent,
        title: PrimaryText("Add Subscription"),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_back, color: UIColor.primary),
          onPressed: () => Navigation.pop(),
        ),

      ),
      body: ChangeNotifierProvider(
        create: (context) => AddSubscriptionProvider(),
        child: AddSubscriptionBody(),
      ),
    );
  }
}
