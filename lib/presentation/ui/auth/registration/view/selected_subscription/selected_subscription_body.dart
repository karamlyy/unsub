import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/auth/registration/provider/select_subscriptions_provider.dart';
import 'package:unsub/presentation/ui/auth/registration/provider/selected_subscription_provider.dart';
import 'package:unsub/presentation/widgets/button/primary_button.dart';
import 'package:unsub/presentation/widgets/text-field/picker_field.dart';
import 'package:unsub/presentation/widgets/text-field/primary_date_field.dart';
import 'package:unsub/presentation/widgets/text-field/primary_textfield.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class SelectedSubscriptionBody extends StatelessWidget {
  const SelectedSubscriptionBody({super.key, required this.selectedSubscription});
  final List<SubscriptionItem> selectedSubscription;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SelectedSubscriptionProvider>();
    final item = selectedSubscription.isNotEmpty ? selectedSubscription[0] : null;

    if (item == null) {
      return SafeArea(
        child: Center(
          child: PrimaryText("No subscriptions selected"),
        ),
      );
    }
    
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(

                child: Image.asset(
                  item.logoAsset,
                  fit: BoxFit.contain,
                  width: 56.w,
                  height: 56.w,
                ),
              ),
            ),
            16.verticalSpace,
            PrimaryText(item.title, fontWeight: FontWeight.w500),
            32.verticalSpace,
            PrimaryTextFormField(
              hintText: "Description",
              keyboardType: TextInputType.text,
              controller: provider.descriptionController,
            ),
            16.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: PrimaryTextFormField(
                    hintText: "Amount",
                    keyboardType: TextInputType.number,
                    controller: provider.amountController,
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: PlatformPickerField<BillingCycle>(
                    titleText: 'Billing Cycle',
                    items: BillingCycle.values,
                    current: provider.billingCycle,
                    displayStringFor: (c) => c.label,
                    onSelected: provider.setBillingCycle,
                  ),
                ),

              ],
            ),
            16.verticalSpace,
            PlatformDateField(
              controller: provider.firstPaymentController,
              selectedDate: provider.firstPaymentDate,
              onDateSelected: provider.setFirstPaymentDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            ),
            24.verticalSpace,
            PrimaryText("Notifications"),
            12.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: UIColor.textfieldBackground,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: PrimaryText("Email")),
                      CupertinoSwitch(
                        value: provider.emailNotifications,
                        onChanged: provider.toggleEmail,
                        activeTrackColor: UIColor.primary,
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      const Expanded(child: PrimaryText("Push")),
                      CupertinoSwitch(
                        value: provider.pushNotifications,
                        onChanged: provider.togglePush,
                        activeTrackColor: UIColor.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Spacer(),
            PrimaryButton(
              title: "Done",
              onPressed: () async {
                try {
                  final form = await provider.submit();
                  context.goNamed('home');
                  debugPrint(
                    'Saved: ${form.description} | ${form.amount} | ${form.billingCycle.label} | ${form.firstPaymentDate} | email=${form.emailNotifications} push=${form.pushNotifications}',
                  );
                } catch (e) {
                  debugPrint('Form error: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}



