import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unsub/data/model/service/services_model.dart';
import 'package:unsub/presentation/ui/add-subscription/provider/add_subscription_provider.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class AddSubscriptionDetailBody extends StatelessWidget {
  const AddSubscriptionDetailBody({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PrimaryText("Add Subscription Detail Body"),
          ],
        ),
      ),
    );
  }
}
