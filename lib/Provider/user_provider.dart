import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _role = 'Azienda Trasporti';

  String get role => _role;

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }
}
