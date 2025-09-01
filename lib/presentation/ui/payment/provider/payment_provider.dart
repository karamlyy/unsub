import 'package:flutter/material.dart';
import 'package:unsub/app/view/di.dart';
import 'package:unsub/data/endpoint/payment/add_payment_method_endpoint.dart';
import 'package:unsub/data/repository/payment_methods_repository.dart';
import 'package:unsub/data/model/payment-methods/payment_methods_model.dart';

class PaymentProvider extends ChangeNotifier {

  final PaymentMethodsRepository _paymentMethodsRepository = locator.get<PaymentMethodsRepository>();

  bool isLoading = true;
  String? errorMessage;
  List<PaymentMethod> paymentMethods = [];

  bool _isDisposed = false;

  PaymentProvider() {
    getPaymentMethods();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (_isDisposed) return;
    notifyListeners();
  }

  Future<void> getCardBrands() async {
    isLoading = true;
    _safeNotify();
    final result = await _paymentMethodsRepository.getCardBrands();
    result.fold((l) {
      errorMessage = l.error.message;
      isLoading = false;
      _safeNotify();
    }, (r) {
      isLoading = false;
      _safeNotify();
    });
  }


  Future<void> getTypes() async {
    isLoading = true;
    _safeNotify();
    final result = await _paymentMethodsRepository.getTypes();
    result.fold((l) {
      errorMessage = l.error.message;
      isLoading = false;
      _safeNotify();
    }, (r) {
      isLoading = false;
      _safeNotify();
    });
  }


  Future<void> getPaymentMethods() async {
    isLoading = true;
    _safeNotify();
    final result = await _paymentMethodsRepository.getPaymentMethods();
    result.fold((l) {
      errorMessage = l.error.message;
      isLoading = false;
      _safeNotify();
    }, (r) {
      paymentMethods = r.data ?? [];
      isLoading = false;
      _safeNotify();
    });
  }

  final input = AddPaymentMethodInput(
    label: "mans",
    value: "mans",
    isDefault: null,
    type: "cash",
    cardBrandId: "",
  );

  Future<void> addPaymentMethod() async {
    isLoading = true;
    _safeNotify();
    final result = await _paymentMethodsRepository.addPaymentMethod(input);
    result.fold((l) {
      errorMessage = l.error.message;
      isLoading = false;
      _safeNotify();
    }, (r) {
      getPaymentMethods();
    });
  }

  Future<void> deletePaymentMethod(String id) async {
    isLoading = true;
    _safeNotify();
    final result = await _paymentMethodsRepository.deletePaymentMethod(id);
    result.fold((l) {
      errorMessage = l.error.message;
      isLoading = false;
      _safeNotify();
    }, (r) {
      getPaymentMethods();
    });
  }


}