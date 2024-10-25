import 'dart:convert';
import 'package:flutter_etrucknet_new/res/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_etrucknet_new/Models/user_model.dart';

class AuthRepository {
  Future<UserModel?> loginApi(Map<String, String> credentials) async {
    try {
      // Esegui la chiamata API per il login utilizzando l'endpoint definito in AppUrl
      final response = await http.post(
        Uri.parse('${AppUrl.baseUrl}/${AppUrl.loginEndPoint}'), // Usa l'URL corretto per il login
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(credentials),
      );

      // Stampa la risposta dell'API per il debug
      print('Response body: ${response.body}');

      // Verifica lo stato della risposta
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Verifica se la risposta contiene i ruoli
        if (jsonResponse['anagraficaRoles'] != null) {
          // Mappa il JSON nel modello UserModel
          return UserModel.fromJson(jsonResponse);
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
}
