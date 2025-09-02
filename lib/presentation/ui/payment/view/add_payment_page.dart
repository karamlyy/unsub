import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/payment/provider/payment_provider.dart';
import 'package:unsub/presentation/ui/payment/view/add_payment_body.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class AddPaymentPage extends StatelessWidget {
  const AddPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_back, color: UIColor.primary),
          onPressed: () => Navigation.pop(),
        ),
        backgroundColor: UIColor.transparent,
        surfaceTintColor: UIColor.transparent,
        title: PrimaryText("Payment", fontSize: 17),
      ),
      body: ChangeNotifierProvider(
        create: (_) => PaymentProvider(),
        child: const AddPaymentBody(),
      ),
    );
  }
}
