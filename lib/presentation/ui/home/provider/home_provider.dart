// home_provider.dart
import 'package:flutter/material.dart';
import 'package:unsub/data/model/subscription_model.dart';

class HomeProvider extends ChangeNotifier {
  final List<Subscription> _items = [];

  List<Subscription> get items => List.unmodifiable(_items);

  void loadMock() {
    if (_items.isNotEmpty) return;
    _items.addAll([
      Subscription(
        id: 1,
        name: 'Telegram Premium',
        vendor: 'Telegram',
        category: SubscriptionCategory.messenger,
        price: 25.00,
        nextBilling: DateTime(2025, 8, 28),
        imageAsset: 'assets/images/telegram.png',
      ),
      Subscription(
        id: 2,
        name: 'Netflix',
        vendor: 'Netflix',
        category: SubscriptionCategory.video,
        price: 12.99,
        nextBilling:  DateTime(2025, 7, 20),
        imageAsset: 'assets/images/netflix.png',
      ),
      Subscription(
        id: 3,
        name: 'Youtube Premium',
        vendor: 'Youtube',
        category: SubscriptionCategory.video,
        price: 7.99,
        nextBilling: DateTime(2025, 7, 28),
        imageAsset: 'assets/images/youtube.png',
      ),
      Subscription(
        id: 4,
        name: 'Apple Music',
        vendor: 'Apple',
        category: SubscriptionCategory.music,
        price: 5.99,
        nextBilling: DateTime(2025, 9, 1),
        imageAsset: 'assets/images/appleMusic.png',
      ),
      Subscription(
        id: 5,
        name: 'ChatGPT Plus',
        vendor: 'OpenAI',
        category: SubscriptionCategory.ai,
        price: 20.00,
        nextBilling: DateTime(2025, 9, 1),
        imageAsset: 'assets/images/openai.png',
      ),

    ]);
    notifyListeners();
  }

  void setFromApi(List<Subscription> data) {
    _items
      ..clear()
      ..addAll(data);
    notifyListeners();
  }

  double sumOfPrices() {
    double total = 0;
    for (var item in _items) {
      total += item.price;
    }
    print("Total price of subscriptions: \$${total.toStringAsFixed(2)}");
    return total;
  }

  bool isExpiringSoon(Subscription sub, {int thresholdInDays = 3}) {
    final daysLeft = sub.nextBilling.difference(DateTime.now()).inDays;
    return daysLeft >= 0 && daysLeft <= thresholdInDays;
  }

  void removeAt(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
  }
}