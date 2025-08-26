extension StringValidation on String {
  bool isValidPassword() {
    return length >= 8 && contains(RegExp(r'[A-Z]'));
  }
}