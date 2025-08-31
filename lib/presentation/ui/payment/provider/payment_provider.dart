import 'package:flutter/material.dart';
import 'package:unsub/data/repository/auth_repository.dart';
import 'package:unsub/data/repository/payment_methods_repository.dart';

import '../../../../app/view/di.dart';

class PaymentProvider extends ChangeNotifier {

  final AuthRepository _authRepository = locator.get<AuthRepository>();
  final PaymentMethodsRepository _paymentMethodsRepository = locator.get<PaymentMethodsRepository>();


  bool isLoading = true;
  String? errorMessage;

  bool _isDisposed = false;

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
      print(r.data);
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
      print(r.data);
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
      print(r.data);
      isLoading = false;
      _safeNotify();
    });
  }

}