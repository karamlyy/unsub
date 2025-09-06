import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unsub/presentation/ui/auth/registration/provider/register_provider.dart';

enum BillingCycle { weekly, monthly, quarterly, yearly, custom }

extension BillingCycleLabel on BillingCycle {
  String get label {
    switch (this) {
      case BillingCycle.weekly: return 'Weekly';
      case BillingCycle.monthly: return 'Monthly';
      case BillingCycle.quarterly: return 'Quarterly';
      case BillingCycle.yearly: return 'Yearly';
      case BillingCycle.custom: return 'Custom';
    }
  }
}

class SelectedSubscriptionForm {
  final String description;
  final double amount;
  final BillingCycle billingCycle;
  final DateTime? firstPaymentDate;
  final bool emailNotifications;
  final bool pushNotifications;

  const SelectedSubscriptionForm({
    required this.description,
    required this.amount,
    required this.billingCycle,
    required this.firstPaymentDate,
    required this.emailNotifications,
    required this.pushNotifications,
  });
}

class SelectedSubscriptionProvider extends RegisterProvider {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController firstPaymentController = TextEditingController();

  BillingCycle _billingCycle = BillingCycle.monthly;
  DateTime? _firstPaymentDate;
  bool _emailNotifications = false;
  bool _pushNotifications = false;

  BillingCycle get billingCycle => _billingCycle;
  DateTime? get firstPaymentDate => _firstPaymentDate;
  bool get emailNotifications => _emailNotifications;
  bool get pushNotifications => _pushNotifications;

  void setBillingCycle(BillingCycle cycle) {
    _billingCycle = cycle;
    notifyListeners();
  }

  void setFirstPaymentDate(DateTime? date) {
    _firstPaymentDate = date;
    if (date != null) {
      firstPaymentController.text = DateFormat('dd/MM/yyyy').format(date);
    } else {
      firstPaymentController.clear();
    }
    notifyListeners();
  }

  void toggleEmail(bool value) {
    _emailNotifications = value;
    notifyListeners();
  }

  void togglePush(bool value) {
    _pushNotifications = value;
    notifyListeners();
  }

  String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount required';
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null) return 'Enter a valid number';
    if (parsed < 0) return 'Must be positive';
    return null;
  }

  bool get isValid {
    if (validateAmount(amountController.text) != null) return false;
    return true;
  }

  SelectedSubscriptionForm buildForm() {
    final amount = double.parse(amountController.text.trim().replaceAll(',', '.'),);
    return SelectedSubscriptionForm(
      description: descriptionController.text.trim(),
      amount: amount,
      billingCycle: _billingCycle,
      firstPaymentDate: _firstPaymentDate,
      emailNotifications: _emailNotifications,
      pushNotifications: _pushNotifications,
    );
  }

  @override
  Future<SelectedSubscriptionForm> submit() async {
    if (!isValid) {
      throw Exception('Form is not valid');
    }
    final form = buildForm();
    return form;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    firstPaymentController.dispose();
    super.dispose();
  }
}