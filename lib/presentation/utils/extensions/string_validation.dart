extension StringValidation on String {
  bool isValidPassword() {
    return length >= 8;
  }
}