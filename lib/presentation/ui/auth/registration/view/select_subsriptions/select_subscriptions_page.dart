import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/auth/registration/provider/select_subscriptions_provider.dart';
import 'package:unsub/presentation/ui/auth/registration/view/select_subsriptions/select_subscriptions_body.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class SelectSubscriptionsPage extends StatelessWidget {
  const SelectSubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: UIColor.transparent,

        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_back, color: UIColor.primary),
          onPressed: () {
            context.goNamed("register");
          },
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: PrimaryText("Skip", color: UIColor.textDisabled, fontSize: 13,),
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => SelectSubscriptionProvider(),
        child: SelectSubscriptionsBody(),
      ),
    );
  }
}
