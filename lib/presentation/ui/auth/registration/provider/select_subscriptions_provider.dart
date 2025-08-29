import 'package:unsub/presentation/ui/auth/registration/provider/register_provider.dart';

class SelectSubscriptionProvider extends RegisterProvider {

  final List<SubscriptionItem> _allSubscriptions = [
    SubscriptionItem(id: 1, title: 'Netflix',     logoAsset: 'assets/images/netflix.png'),
    SubscriptionItem(id: 2, title: 'Spotify',     logoAsset: 'assets/images/spotify.png'),
    SubscriptionItem(id: 3, title: 'YouTube',     logoAsset: 'assets/images/youtube.png'),
    SubscriptionItem(id: 4, title: 'Apple Music', logoAsset: 'assets/images/appleMusic.png'),
    SubscriptionItem(id: 5, title: 'Telegram',    logoAsset: 'assets/images/telegram.png'),
    SubscriptionItem(id: 6, title: 'Roblox',      logoAsset: 'assets/images/roblox.png'),
    SubscriptionItem(id: 7, title: 'Kinopoisk',   logoAsset: 'assets/images/kinopoisk.png'),
    SubscriptionItem(id: 8, title: 'VKontakte',   logoAsset: 'assets/images/vkontakt.png'),
    SubscriptionItem(id: 9, title: 'SoundCloud',  logoAsset: 'assets/images/soundcloud.png'),
  ];

  String _query = '';

  List<SubscriptionItem> get subscriptions {
    if (_query.isEmpty) return List.unmodifiable(_allSubscriptions);
    final q = _query.toLowerCase();
    return List.unmodifiable(
      _allSubscriptions.where((e) => e.title.toLowerCase().contains(q)),
    );
  }

  List<int> get selectedIds => _allSubscriptions.where((e) => e.isSelected).map((e) => e.id).toList();

  List<SubscriptionItem> get selectedSubscriptions => _allSubscriptions.where((e) => e.isSelected).toList();

  int get selectedCount => selectedIds.length;

  bool get hasAnySelected => selectedCount > 0;

  void updateQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void toggleSubscription(int id) {
    final i = _allSubscriptions.indexWhere((e) => e.id == id);
    if (i == -1) return;
    final current = _allSubscriptions[i];
    _allSubscriptions[i] = current.copyWith(isSelected: !current.isSelected);
    notifyListeners();
  }

}


class SubscriptionItem {
  final int id;
  final String title;
  final String logoAsset;
  final bool isSelected;

  const SubscriptionItem({
    required this.id,
    required this.title,
    required this.logoAsset,
    this.isSelected = false,
  });


  SubscriptionItem copyWith({bool? isSelected}) => SubscriptionItem(
    id: id,
    title: title,
    logoAsset: logoAsset,
    isSelected: isSelected ?? this.isSelected,
  );
}