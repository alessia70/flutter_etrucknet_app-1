import 'package:flutter_etrucknet_new/DTOs/stima_dto.dart';

class ApiService {
  final List<Stima> _stime = [];

  // Simula il recupero delle stime
  Future<List<Stima>> getStime() async {
    // Simula un'attesa per il caricamento
    await Future.delayed(Duration(seconds: 1));
    return _stime;  // Ritorna i dati fittizi
  }

  // Simula la creazione di una nuova stima
  Future<void> createStima(Map<String, dynamic> stimaData) async {
    // Simula un'attesa per la creazione
    await Future.delayed(Duration(seconds: 1));

    // Aggiungi una nuova stima ai dati fittizi
    _stime.add(Stima.fromJson(stimaData));
  }
}
