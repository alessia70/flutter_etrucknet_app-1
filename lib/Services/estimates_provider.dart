import 'package:flutter/material.dart';

class EstimatesProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _estimates = [
    {
      'id': 1,
      'data': '2024-09-15',
      'utente': 'Utente A',
      'carico': 'Carico A',
      'scarico': 'Scarico A',
      'stimato': '1000 USD',
    },
    {
      'id': 2,
      'data': '2024-09-16',
      'utente': 'Utente B',
      'carico': 'Carico B',
      'scarico': 'Scarico B',
      'stimato': '1500 USD',
    },
  ];

  List<Map<String, dynamic>> get estimates => _estimates;

  void addEstimate(Map<String, dynamic> estimate) {
    int newId = _estimates.isNotEmpty
        ? (_estimates.last['id'] as int) + 1
        : 1;

    estimate['id'] = newId;

    _estimates.add(estimate);
    notifyListeners(); 
  }
}
