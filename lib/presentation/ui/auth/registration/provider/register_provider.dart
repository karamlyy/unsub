import 'package:flutter/material.dart';
import 'package:unsub/presentation/utils/extensions/string_validation.dart';

class RegisterProvider extends ChangeNotifier {
  String _username = '';
  String _password = '';
  String _confirmPassword = '';

  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;

  String get username => _username;

  String get password => _password;

  String get confirmPassword => _confirmPassword;

  String? get usernameError => _usernameError;

  String? get passwordError => _passwordError;

  String? get confirmPasswordError => _confirmPasswordError;

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

  bool get isFormValid {
    final isValidField = _usernameError == null && _passwordError == null && _confirmPasswordError == null;
    final isValidValue = _username.isNotEmpty && _password.isNotEmpty && _confirmPassword.isNotEmpty && _password == _confirmPassword;
    return isValidField && isValidValue;
  }
}
