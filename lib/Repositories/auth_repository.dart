import 'package:flutter_etrucknet_new/res/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_etrucknet_new/Models/user_model.dart';

class AuthRepository {
  Future<UserModel?> loginApi(Map<String, String> credentials) async {
    try {
      // Esegui la chiamata API per il login utilizzando l'endpoint definito in AppUrl
      final response = await http.post(
        Uri.parse('${AppUrl.baseUrl}/${AppUrl.loginEndPoint}'),
        headers: {"Content-Type": "application/x-www-form-urlencoded"}, // Modificato l'intestazione
        body: credentials, // Usa direttamente credentials senza jsonEncode
      );

      // Stampa la risposta dell'API per il debug
      print('Response body: ${response.body}');

      // Verifica lo stato della risposta
      if (response.statusCode == 200) {
        // Supponiamo che la risposta sia in formato text o in altro formato, gestisci di conseguenza
        // Ad esempio, se la risposta è in formato JSON:
        final Map<String, dynamic> jsonResponse = parseResponse(response.body);

        // Verifica se la risposta contiene i ruoli
        if (jsonResponse['anagraficaRoles'] != null) {
          // Mappa il JSON nel modello UserModel
          return UserModel.fromForm(jsonResponse); // Assicurati di avere questo metodo corretto
        } else {
          print('Ruoli non trovati nella risposta');
        }
      } else {
        print('Errore: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante il login: $e');
    }
    return null;
  }

  // Funzione per parsare la risposta se è in formato diverso
  Map<String, dynamic> parseResponse(String responseBody) {
    return {}; // Placeholder
  }
}
