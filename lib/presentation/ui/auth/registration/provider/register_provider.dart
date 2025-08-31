import 'package:flutter/material.dart';
import 'package:unsub/app/generic/generic_state.dart';
import 'package:unsub/app/view/di.dart';
import 'package:unsub/data/endpoint/auth/register_endpoint.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/repository/auth_repository.dart';
import 'package:unsub/data/service/preferences/preferences.dart';
import 'package:unsub/presentation/utils/extensions/string_validation.dart';

class RegisterProvider extends ChangeNotifier {
  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  bool _autoSignIn = false;

  GenericState _state = Initial();
  final AuthRepository _authRepository = locator.get<AuthRepository>();

  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;

  String get username => _username;

  String get password => _password;

  String get confirmPassword => _confirmPassword;
  bool get autoSignIn => _autoSignIn;

  String? get usernameError => _usernameError;

  String? get passwordError => _passwordError;

  String? get confirmPasswordError => _confirmPasswordError;
  GenericState get state => _state;

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

  void updateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    if (_confirmPassword == _password) {
      _confirmPasswordError = null;
    } else {
      _confirmPasswordError = 'Passwords do not match';
    }
    notifyListeners();
  }

  void toggleAutoSignIn(bool value) {
    _autoSignIn = value;
    notifyListeners();
  }

  bool get isFormValid {
    final isValidField = _usernameError == null && _passwordError == null && _confirmPasswordError == null;
    final isValidValue = _username.isNotEmpty && _password.isNotEmpty && _confirmPassword.isNotEmpty && _password == _confirmPassword;
    return isValidField && isValidValue;
  }

  Future<void> submit() async {
    _state = InProgress();
    notifyListeners();

    final input = RegisterInput(username: _username, password: _password, autoSignIn: _autoSignIn);
    final prefs = await PreferencesService.instance;
    final result = await _authRepository.register(input);
    result.fold((l) {
      _state = Failure(ErrorMessage(message: l.error.message));
      notifyListeners();
    }, (r) async {
      if (_autoSignIn) {
        await prefs.setAuthorizationPassed(true);
        await prefs.setAccessToken(r.accessToken ?? "");
        await prefs.setRefreshToken(r.refreshToken ?? "");
      }
      _state = Success();
      notifyListeners();
    });
  }

  void resetState() {
    _state = Initial();
    notifyListeners();
  }
}
