import 'package:flutter/material.dart';
import 'package:unsub/data/model/subscription_model.dart';

class AddSubscriptionProvider extends ChangeNotifier {
  final List<SubscriptionItem> _items = [];

  List<SubscriptionItem> get items => List.unmodifiable(_items);

  void loadMock() {
    if (_items.isNotEmpty) return;
    _items.addAll([
      SubscriptionItem(id: 1, title: 'Netflix',      logoAsset: 'assets/images/netflix.png',     category: SubscriptionCategory.video),
      SubscriptionItem(id: 2, title: 'Youtube',      logoAsset: 'assets/images/youtube.png',     category: SubscriptionCategory.video,   isSelected: true),
      SubscriptionItem(id: 3, title: 'Apple Music',  logoAsset: 'assets/images/appleMusic.png',  category: SubscriptionCategory.music,   isSelected: true),
      SubscriptionItem(id: 4, title: 'Spotify',      logoAsset: 'assets/images/spotify.png',     category: SubscriptionCategory.music),
      SubscriptionItem(id: 5, title: 'Telegram',     logoAsset: 'assets/images/telegram.png',    category: SubscriptionCategory.messenger),
      SubscriptionItem(id: 6, title: 'Roblox',       logoAsset: 'assets/images/roblox.png',      category: SubscriptionCategory.game),
      SubscriptionItem(id: 7, title: 'Kinopoisk',    logoAsset: 'assets/images/kinopoisk.png',   category: SubscriptionCategory.video),
      SubscriptionItem(id: 8, title: 'VKontakte',    logoAsset: 'assets/images/vkontakt.png',    category: SubscriptionCategory.messenger),
      SubscriptionItem(id: 9, title: 'ChatGPT',      logoAsset: 'assets/images/openai.png',      category: SubscriptionCategory.ai),
    ]);
    notifyListeners();
  }

  String _query = '';
  void updateQuery(String value) {
    _query = value;
    notifyListeners();
  }

  SubscriptionCategory? _selectedCategory;
  SubscriptionCategory? get selectedCategory => _selectedCategory;

  void setCategory(SubscriptionCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<SubscriptionItem> get subscriptions {
    Iterable<SubscriptionItem> list = _items;

    if (_selectedCategory != null) {
      list = list.where((e) => e.category == _selectedCategory);
    }

    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((e) => e.title.toLowerCase().contains(q));
    }

    return List.unmodifiable(list);
  }

  List<int> get selectedIds =>
      _items.where((e) => e.isSelected).map((e) => e.id).toList();

  List<SubscriptionItem> get selectedSubscriptions =>
      _items.where((e) => e.isSelected).toList();

  int get selectedCount => selectedIds.length;

  bool get hasAnySelected => selectedCount > 0;

  void toggleSubscription(int id) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i == -1) return;
    final current = _items[i];
    _items[i] = current.copyWith(isSelected: !current.isSelected);
    notifyListeners();
  }
}

class SubscriptionItem {
  final int id;
  final String title;
  final String logoAsset;
  final bool isSelected;
  final SubscriptionCategory category;

  const SubscriptionItem({
    required this.id,
    required this.title,
    required this.logoAsset,
    this.isSelected = false,
    this.category = SubscriptionCategory.other,
  });

  SubscriptionItem copyWith({bool? isSelected}) => SubscriptionItem(
    id: id,
    title: title,
    logoAsset: logoAsset,
    isSelected: isSelected ?? this.isSelected,
    category: category,
  );
}