import 'package:flutter/material.dart';

class EditProfileProvider extends ChangeNotifier{

  String name = "";

  void updateName(String value) {
    name = value;
    notifyListeners();
  }

  String username = "";
  void updateUsername(String value) {
    username = value;
    notifyListeners();
  }

  Future<void> saveProfile() async {
    await Future.delayed(const Duration(milliseconds: 800));
    name = name;
    username = username;
    notifyListeners();
  }
}