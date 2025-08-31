import 'package:flutter/material.dart';
import 'package:unsub/data/endpoint/auth/login_endpoint.dart';
import 'package:unsub/app/generic/generic_state.dart';
import 'package:unsub/app/view/di.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/repository/auth_repository.dart';
import 'package:unsub/data/service/preferences/preferences.dart';
import 'package:unsub/presentation/utils/extensions/string_validation.dart';

class LoginProvider extends ChangeNotifier {
  String _username = '';
  String _password = '';

  String? _usernameError;
  String? _passwordError;

  bool _isPasswordVisible = false;

  GenericState _state = Initial();
  final AuthRepository _authRepository = locator.get<AuthRepository>();

  String get username => _username;

  String get password => _password;

  String? get usernameError => _usernameError;

  String? get passwordError => _passwordError;

  bool get isPasswordVisible => _isPasswordVisible;

  LoginInput get loginInput => LoginInput(username: _username, password: _password);

  GenericState get state => _state;

  void changePasswordVisibility(bool value) {
    _isPasswordVisible = value;
    notifyListeners();
  }

  void updateUsername(String username) {
    _username = username;
    if (_username.length >= 3) {
      _usernameError = null;
    } else {
      _usernameError = 'Username format is invalid';
    }
    notifyListeners();
  }

  void updatePassword(String password) {
    _password = password;
    if (_password.isValidPassword()) {
      _passwordError = null;
    } else {
      _passwordError = 'Password is too short';
    }
    notifyListeners();
  }

  Future<void> login() async {
    _state = InProgress();
    notifyListeners();
    final prefs = await PreferencesService.instance;
    final result = await _authRepository.login(loginInput);
    result.fold((l) {
      _state = Failure(ErrorMessage(message: l.error.message));
      notifyListeners();
    }, (r) async {
      await prefs.setAuthorizationPassed(true);
      await prefs.setAccessToken(r.accessToken ?? "");
      await prefs.setRefreshToken(r.refreshToken ?? "");
      _state = Success();
      notifyListeners();
    });
  }

  void resetState() {
    _state = Initial();
    notifyListeners();
  }

  bool get isFormValid {
    final isValidField = _usernameError == null && _passwordError == null;
    final isValidValue = _username.isNotEmpty && _password.isNotEmpty;
    return isValidField && isValidValue;
  }
}
