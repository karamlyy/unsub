import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unsub/presentation/navigation/app_router.dart';
import 'package:unsub/presentation/navigation/navigation.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/payment/provider/payment_provider.dart';
import 'package:unsub/presentation/widgets/button/primary_button.dart';
import 'package:unsub/data/model/payment-methods/payment_methods_model.dart';
import 'package:unsub/presentation/widgets/dialog/confirm_dialog.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class PaymentBody extends StatelessWidget {
  const PaymentBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText('Payment Methods', fontSize: 20),
            16.verticalSpace,
            Expanded(
              child: provider.isLoading
                  ? ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return const _PaymentMethodCardSkeleton();
                      },
                    )
                  : provider.errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: UIColor.error,
                          ),
                          16.verticalSpace,
                          PrimaryText('Error'),
                          8.verticalSpace,
                          PrimaryText(provider.errorMessage!),
                          16.verticalSpace,
                          ElevatedButton(
                            onPressed: () => provider.getPaymentMethods(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : provider.paymentMethods.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.payment_outlined,
                            size: 64.sp,
                            color: Colors.grey[400],
                          ),
                          16.verticalSpace,
                          PrimaryText('No payment methods yet'),
                          8.verticalSpace,
                          PrimaryText(
                            'Add your first payment method to get started',
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.paymentMethods.length,
                      itemBuilder: (context, index) {
                        final paymentMethod = provider.paymentMethods[index];
                        return PaymentMethodCard(
                          paymentMethod: paymentMethod,
                          onDelete: () async {
                            final confirm = await showDeleteConfirmDialog(
                              context,
                            );
                            if (confirm && paymentMethod.id != null) {
                              provider.deletePaymentMethod(paymentMethod.id!);
                            }
                          },
                        );
                      },
                    ),
            ),
            16.verticalSpace,
            PrimaryButton(
              title: "Add New Payment Method",
              onPressed: () async {
                final result = await Navigation.push(Routes.addPayment);
                if (result == true) {
                  provider.getPaymentMethods();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final VoidCallback? onDelete;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            _getPaymentMethodIcon(paymentMethod.type),
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          paymentMethod.label ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          paymentMethod.value ?? '',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (paymentMethod.datumDefault == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PrimaryText("default", fontSize: 13,),
              ),
            IconButton(
              icon: const Icon(Icons.delete, color: UIColor.error),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentMethodIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'card':
      case 'cash':
        return Icons.money;
      default:
        return Icons.payment;
    }
  }
}

class _PaymentMethodCardSkeleton extends StatelessWidget {
  const _PaymentMethodCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withValues(alpha: 0.06),
        highlightColor: Colors.white.withValues(alpha: 0.12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white10,
          ),
          title: Container(
            height: 16.h,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          subtitle: Container(
            height: 14.h,
            width: 120.w,
            margin: EdgeInsets.only(top: 4.h),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(7.r),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              8.horizontalSpace,
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
