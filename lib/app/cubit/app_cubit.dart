import 'package:flutter/foundation.dart';
import 'package:unsub/app/cubit/app_state.dart';
import 'package:unsub/app/generic/generic_state.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/service/preferences/preferences.dart';


class AppProvider extends ChangeNotifier {
  GenericState _state = Initial();

  GenericState get state => _state;

  AppProvider() {
    check();
  }

  Future<void> check() async {
    _state = Onboarding();
    notifyListeners();
    final prefs = await PreferencesService.instance;

    try {
      if (!prefs.wasAuthorizationPassed) {
        _state = Unauthorized();
        notifyListeners();
        return;
      }
      _state = Authorized();
      notifyListeners();
    } on HttpException {
      await prefs.clear();
      _state = Unauthorized();
      notifyListeners();
    }
  }
}
