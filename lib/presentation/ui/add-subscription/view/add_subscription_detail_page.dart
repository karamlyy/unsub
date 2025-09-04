import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unsub/data/model/service/services_model.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/add-subscription/provider/add_subscription_provider.dart';
import 'package:unsub/presentation/ui/add-subscription/view/add_subscription_detail_body.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class AddSubscriptionDetailPage extends StatelessWidget {
  final Map<String, dynamic>? arguments;
  
  const AddSubscriptionDetailPage({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    final selectedServiceJson = arguments?['selectedService'] as Map<String, dynamic>?;
    final selectedService = selectedServiceJson != null 
        ? Service.fromJson(selectedServiceJson) 
        : null;

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
        child: AddSubscriptionDetailBody(selectedService: selectedService),
      ),
    );
  }
}
