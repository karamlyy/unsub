import 'package:flutter/material.dart';
import 'package:unsub/app/view/di.dart';
import 'package:unsub/data/model/subscription/subscriptions_model.dart';
import 'package:unsub/data/repository/subscriptions_repository.dart';

class HomeProvider extends ChangeNotifier {

  HomeProvider() {
    getSubscriptions();
  }

  final SubscriptionsRepository _subscriptionsRepository = locator.get<SubscriptionsRepository>();
  List<Subscription> subscriptions = [];

  bool isLoading = true;
  bool _isDisposed = false;
  String? errorMessage;

  @override
  void dispose() {

    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (_isDisposed) return;
    notifyListeners();
  }



  Future<void> getSubscriptions() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _subscriptionsRepository.getSubscriptions();
    result.fold(
          (l) {
        errorMessage = l.error.message;
        isLoading = false;
        _safeNotify();
      },
          (r) {
        subscriptions = r.data ?? [];
        isLoading = false;
        _safeNotify();
      },
    );
  }

  void removeAt(int index) {
    if (index < 0 || index >= subscriptions.length) return;
    subscriptions.removeAt(index);
    notifyListeners();
  }

  bool isExpiringSoon(Subscription sub, {int thresholdInDays = 3}) {
    final daysLeft = sub.nextPaymentDate!.difference(DateTime.now()).inDays;
    return daysLeft >= 0 && daysLeft <= thresholdInDays;
  }

  int sumOfPrices() {
    int total = 0;
    for (var item in subscriptions) {
      total += item.price ?? 0;
    }
    return total;
  }
}