import 'package:flutter/material.dart';
import 'package:unsub/presentation/utils/extensions/string_validation.dart';

class LoginProvider extends ChangeNotifier {
  String _username = '';
  String _password = '';

  String? _usernameError;
  String? _passwordError;

  bool _isPasswordVisible = false;

  String get username => _username;

  String get password => _password;

  String? get usernameError => _usernameError;

  String? get passwordError => _passwordError;

  bool get isPasswordVisible => _isPasswordVisible;

  //LoginInput get loginInput => LoginInput(username: _username, password: _password);

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

  bool get isFormValid {
    final isValidField = _usernameError == null && _passwordError == null;
    final isValidValue = _username.isNotEmpty && _password.isNotEmpty;
    print(isValidField);
    print(isValidValue);
    return isValidField && isValidValue;
  }
}
