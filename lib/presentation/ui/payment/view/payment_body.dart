import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsub/presentation/ui/payment/provider/payment_provider.dart';
import 'package:unsub/presentation/widgets/button/primary_button.dart';
import 'package:unsub/data/model/payment-methods/payment_methods_model.dart';

class PaymentBody extends StatelessWidget {
  const PaymentBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Methods',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.red[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              provider.errorMessage!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.red[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
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
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No payment methods yet',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add your first payment method to get started',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: provider.paymentMethods.length,
                            itemBuilder: (context, index) {
                              final paymentMethod = provider.paymentMethods[index];
                              return Dismissible(
                                key: Key(paymentMethod.id ?? index.toString()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20.0),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  return await _showDeleteConfirmationDialog(
                                    context,
                                    paymentMethod.label ?? 'Unknown',
                                  );
                                },
                                onDismissed: (direction) {
                                  if (paymentMethod.id != null) {
                                    provider.deletePaymentMethod(paymentMethod.id!);
                                  }
                                },
                                child: PaymentMethodCard(
                                  paymentMethod: paymentMethod,
                                ),
                              );
                            },
                          ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              title: "Add New Payment Method",
              onPressed: provider.addPaymentMethod,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(
    BuildContext context,
    String paymentMethodName,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Payment Method'),
          content: Text(
            'Are you sure you want to delete "$paymentMethodName"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod paymentMethod;

  const PaymentMethodCard({required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
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
        trailing: paymentMethod.datumDefault == true
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  IconData _getPaymentMethodIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'card':
      case 'credit':
      case 'debit':
        return Icons.credit_card;
      case 'cash':
        return Icons.money;
      case 'bank':
        return Icons.account_balance;
      case 'paypal':
        return Icons.payment;
      default:
        return Icons.payment;
    }
  }
}
