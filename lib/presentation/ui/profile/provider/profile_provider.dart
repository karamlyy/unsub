import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:unsub/app/view/di.dart';
import 'package:unsub/data/repository/auth_repository.dart';
import 'package:unsub/data/repository/payment_methods_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final AuthRepository _authRepository = locator.get<AuthRepository>();
  final PaymentMethodsRepository _paymentMethodsRepository = locator.get<PaymentMethodsRepository>();


  String username = "";
  bool isLoading = true;
  String? errorMessage;

  bool _isDisposed = false;

  ProfileProvider() {
    _loadMe();
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

  Future<void> _loadMe() async {
    isLoading = true;
    _safeNotify();
    final result = await _authRepository.me();
    result.fold(
      (l) {
        errorMessage = l.error.message;
        isLoading = false;
        _safeNotify();
      },
      (r) {
        username = r.username;
        isLoading = false;
        _safeNotify();
      },
    );
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



  void logout() {
    print("User logged out");
  }
}
