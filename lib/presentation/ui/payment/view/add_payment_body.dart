import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/payment/provider/payment_provider.dart';
import 'package:unsub/presentation/widgets/bottom-sheet/primary_bottom_sheet.dart';
import 'package:unsub/presentation/widgets/bottom-sheet/selection_bottom_sheet.dart';
import 'package:unsub/presentation/widgets/button/primary_button.dart';
import 'package:unsub/presentation/widgets/text-field/primary_textfield.dart';

class AddPaymentBody extends StatelessWidget {
  const AddPaymentBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            PrimaryTextFormField(
              headerText: "card title",
              hintText: "name of card",
              keyboardType: TextInputType.number,
              onChanged: provider.setLabel,
            ),
            16.verticalSpace,
            PrimaryTextFormField(
              headerText: "card number",
              hintText: "last four digits of card",
              keyboardType: TextInputType.number,
              onChanged: provider.setLast4,
            ),
            16.verticalSpace,
            PrimaryTextFormField(
              headerText: "payment type",
              hintText: "select type",
              controller: provider.paymentTypeController,
              readOnly: true,
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
              onTap: () async {
                await provider.getTypes();
                await SelectionBottomSheet.show(
                  context,
                  title: "Select types",
                  options: provider.types,
                  selected: provider.selectedPaymentType,
                  onSelected: (val) => provider.selectPaymentType(val),
                );
              },
            ),

            16.verticalSpace,

            PrimaryTextFormField(
              headerText: "card brand",
              hintText: "select brand",
              controller: provider.cardBrandController,
              readOnly: true,
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
              onTap: () async {
                if ((provider.selectedType ?? '').toLowerCase() == 'cash') {
                  PrimaryBottomSheet.show(context, text: 'Cash type does not use a card brand');
                  return;
                }
                await provider.getCardBrands();
                final labels = provider.cardBrands
                    .map((e) => e.type ?? '')
                    .where((e) => e.isNotEmpty)
                    .toList();
                await SelectionBottomSheet.show(
                  context,
                  title: "Select card brand",
                  options: labels,
                  selected: provider.selectedCardBrand,
                  onSelected: (val) => provider.selectCardBrand(val),
                );
              },
            ),
            16.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Set as default",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                CupertinoSwitch(
                  value: provider.newIsDefault,
                  onChanged: provider.setIsDefault,
                  activeTrackColor: UIColor.primary,
                ),
              ],
            ),

            16.verticalSpace,
            Spacer(),
            PrimaryButton(
              title: "confirm",
              onPressed: () async {
                await provider.addPaymentMethod();
                if (provider.errorMessage != null) {
                  PrimaryBottomSheet.show(
                    context,
                    text: provider.errorMessage!,
                  );
                  return;
                }
                Navigation.pop(true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
