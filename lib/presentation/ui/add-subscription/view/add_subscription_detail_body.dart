import 'package:flutter/material.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class AddSubscriptionDetailBody extends StatelessWidget {
  const AddSubscriptionDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PrimaryText("Add Subscription Detail Body"));
  }
}
