import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/allestimento_model.dart';
import 'package:flutter_etrucknet_new/Services/tipoAllestimento_services.dart';

class AllestimentoProvider extends ChangeNotifier {
  final TipoAllestimentoService _service = TipoAllestimentoService();

  List<Allestimento> _allestimenti = [];
  List<Allestimento> get allestimenti => _allestimenti;

  Future<void> loadAllestimenti() async {
    try {
      _allestimenti = await _service.fetchTipoAllestimenti();
      notifyListeners();
    } catch (e) {
      print("Errore durante il caricamento degli allestimenti: $e");
    }
  }
}
