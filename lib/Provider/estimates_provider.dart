import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class EstimatesProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _estimates = [];

  List<Map<String, dynamic>> get estimates => _estimates;

  void addEstimate(Map<String, dynamic> estimate) {
    int newId = _estimates.isNotEmpty
        ? (_estimates.last['id'] as int) + 1
        : 1;

    estimate['id'] = newId;

    _estimates.add(estimate);
    notifyListeners(); 
  }

  void updateEstimate(int id, Map<String, dynamic> updatedEstimate) {
    final index = _estimates.indexWhere((estimate) => estimate['id'] == id);
    if (index != -1) {
      _estimates[index] = updatedEstimate;
      notifyListeners();
    } else {
      throw Exception('Stima con ID $id non trovata.');
    }
  }

  Future<void> updateSimulation(int simulationId, Map<String, dynamic> updatedSimulation) async {
    final Database db = await openDatabase('simulations.db');

    try {
      await db.update(
        'simulations',
        updatedSimulation,
        where: 'id = ?',
        whereArgs: [simulationId],
      );
    } catch (e) {
      log('Errore durante l\'aggiornamento della simulazione: $e');
    } finally {
      await db.close();
    }
  }
}
