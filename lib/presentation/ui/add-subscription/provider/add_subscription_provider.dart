import 'package:flutter/material.dart';
import 'package:unsub/app/view/di.dart';
import 'package:unsub/data/model/service/categories_model.dart';
import 'package:unsub/data/model/service/services_model.dart';
import 'package:unsub/data/model/subscription_model.dart';
import 'package:unsub/data/repository/services_repository.dart';

class AddSubscriptionProvider extends ChangeNotifier {
  final ServicesRepository _servicesRepository = locator.get<ServicesRepository>();



  List<ServiceModel> services = [];
  List<Category> categories = [];
  bool isLoading = true;
  String? errorMessage;

  String? searchQuery;
  void updateSearchQuery(String? query) {
    searchQuery = query;
    _safeNotify();
  }

  String? _selectedCategoryId;
  String? get selectedCategoryId => _selectedCategoryId;

  void selectCategory(String? id) {
    _selectedCategoryId = id;
    _safeNotify();
  }

  List<Service> get filteredServices {
    final flat = services.expand((g) => g.services ?? const <Service>[]).toList();
    if (_selectedCategoryId == null) return flat;
    return services
        .where((g) => g.categoryId == _selectedCategoryId)
        .expand((g) => g.services ?? const <Service>[])
        .toList();
  }

  // Selected service state
  Service? _selectedService;
  Service? get selectedService => _selectedService;

  void selectService(Service? service) {
    _selectedService = service;
    _safeNotify();
  }


  bool _isDisposed = false;
  AddSubscriptionProvider() {
    getCategories();
    getServices();
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

  Future<void> getServices() async {
    isLoading = true;
    _safeNotify();
    final result = await _servicesRepository.getServices();
    result.fold(
      (l) {
        errorMessage = l.error.message;
        isLoading = false;
        _safeNotify();
      },
      (r) {
        services = r.data ?? [];
        isLoading = false;
        _safeNotify();
      },
    );
  }


  Future<void> getCategories() async {
    isLoading = true;
    _safeNotify();
    final result = await _servicesRepository.getCategories();
    result.fold(
      (l) {
        errorMessage = l.error.message;
        isLoading = false;
        _safeNotify();
      },
      (r) {
        categories = r.data ?? [];
        isLoading = false;
        _safeNotify();
      },
    );
  }


}

