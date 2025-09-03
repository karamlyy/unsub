import 'package:flutter/material.dart';
import 'package:unsub/app/view/di.dart';
import 'package:unsub/data/endpoint/payment/add_payment_method_endpoint.dart';
import 'package:unsub/data/model/payment-methods/card_brands_model.dart';
import 'package:unsub/data/repository/payment_methods_repository.dart';
import 'package:unsub/data/model/payment-methods/payment_methods_model.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentMethodsRepository _paymentMethodsRepository = locator.get<PaymentMethodsRepository>();

  bool isLoading = true;
  String? errorMessage;
  List<PaymentMethod> paymentMethods = [];
  List<String> types = [];
  List<CardBrandModel> cardBrands = [];

  final paymentTypeController = TextEditingController();
  final cardBrandController = TextEditingController();


  void selectPaymentType(String value) {
    paymentTypeController.text = value;
    setType(value);

    if ((value).toLowerCase() == 'cash') {
      selectedCardBrandId = null;
      cardBrandController.clear();
    }

    _safeNotify();
  }

  void selectCardBrand(String value) {
    if ((selectedType ?? '').toLowerCase() == 'cash') {
      errorMessage = 'Cash payment cannot have a card brand';
      selectedType = null;
      paymentTypeController.clear();
      _safeNotify();
      return;
    }

    cardBrandController.text = value;
    final matched = cardBrands.firstWhere((b) => b.label == value || b.type == value, orElse: () => CardBrandModel(),);
    setCardBrandId(matched.id);
    _safeNotify();
  }


  String? get selectedPaymentType => paymentTypeController.text.isNotEmpty ? paymentTypeController.text : null;
  String? get selectedCardBrand => cardBrandController.text.isNotEmpty ? cardBrandController.text : null;


  String? newLabel;
  String? newLast4;
  String? selectedType;
  String? selectedCardBrandId;
  bool newIsDefault = false;

  void setLabel(String v) {
    newLabel = v.trim();
    _safeNotify();
  }

  void setLast4(String v) {
    newLast4 = v.replaceAll(' ', '');
    _safeNotify();
  }

  void setType(String? v) {
    selectedType = v;
    _safeNotify();
  }

  void setCardBrandId(String? v) {
    selectedCardBrandId = v;
    _safeNotify();
  }

  void setIsDefault(bool v) {
    newIsDefault = v;
    _safeNotify();
  }

  bool _isDisposed = false;

  PaymentProvider() {
    getPaymentMethods();
  }

  @override
  void dispose() {
    paymentTypeController.dispose();
    cardBrandController.dispose();
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
    result.fold(
      (l) {
        errorMessage = l.error.message;
        isLoading = false;
        _safeNotify();
      },
      (r) {
        cardBrands = r.data ?? [];
        isLoading = false;
        _safeNotify();
      },
    );
  }

  Future<void> getTypes() async {
    isLoading = true;
    _safeNotify();
    final result = await _paymentMethodsRepository.getTypes();
    result.fold(
      (l) {
        errorMessage = l.error.message;
        isLoading = false;
        _safeNotify();
      },
      (r) {
        types = r.data ?? [];
        isLoading = false;
        _safeNotify();
      },
    );
  }

  Future<void> getPaymentMethods() async {
    isLoading = true;
    _safeNotify();
    final result = await _paymentMethodsRepository.getPaymentMethods();
    result.fold(
      (l) {
        errorMessage = l.error.message;
        isLoading = false;
        _safeNotify();
      },
      (r) {
        paymentMethods = r.data ?? [];
        isLoading = false;
        _safeNotify();
      },
    );
  }

  Future<void> addPaymentMethod() async {
    errorMessage = null;

    final label = (newLabel ?? '').trim();
    final last4 = (newLast4 ?? '').replaceAll(' ', '');
    final type = (selectedType ?? '').trim().toLowerCase();
    String brandId = (selectedCardBrandId ?? '').trim();

    if (label.isEmpty) {
      errorMessage = 'Card title is required';
      _safeNotify();
      return;
    }
    if (last4.length != 4 || int.tryParse(last4) == null) {
      errorMessage = 'Enter exactly 4 digits for the card number';
      _safeNotify();
      return;
    }
    if (type.isEmpty) {
      errorMessage = 'Please select a payment type';
      _safeNotify();
      return;
    }

    if (type == 'cash') {
      brandId = "";
    } else {
      if (brandId.isEmpty) {
        errorMessage = 'Please select a card brand';
        _safeNotify();
        return;
      }
    }

    isLoading = true;
    _safeNotify();

    final input = AddPaymentMethodInput(
      label: label,
      value: last4,
      isDefault: newIsDefault ? true : null,
      type: type,
      cardBrandId: brandId,
    );

    final result = await _paymentMethodsRepository.addPaymentMethod(input);
    result.fold(
          (l) {
        errorMessage = l.error.message;
        isLoading = false;
        _safeNotify();
      },
          (r) async {
        _resetForm();
        paymentTypeController.clear();
        cardBrandController.clear();
        await getPaymentMethods();
        isLoading = false;
        _safeNotify();
      },
    );
  }

  Future<void> deletePaymentMethod(String id) async {
    isLoading = true;
    _safeNotify();
    final result = await _paymentMethodsRepository.deletePaymentMethod(id);
    result.fold(
      (l) {
        errorMessage = l.error.message;
        isLoading = false;
        _safeNotify();
      },
      (r) {
        getPaymentMethods();
      },
    );
  }

  void _resetForm() {
    newLabel = null;
    newLast4 = null;
    selectedType = null;
    selectedCardBrandId = null;
    newIsDefault = false;
  }
}
