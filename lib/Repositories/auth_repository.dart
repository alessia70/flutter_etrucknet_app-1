import 'dart:developer';

import 'package:flutter_etrucknet_new/res/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_etrucknet_new/Models/user_model.dart';

class AuthRepository {
  Future<UserModel?> loginApi(Map<String, String> credentials) async {
    try {
      final response = await http.post(
        Uri.parse('${AppUrl.baseUrl}/${AppUrl.loginEndPoint}'),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: credentials,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = parseResponse(response.body);
        if (jsonResponse['anagraficaRoles'] != null) {
          return UserModel.fromForm(jsonResponse);
        } else {
          log('Ruoli non trovati nella risposta');
        }
      } else {
        log('Errore: ${response.statusCode}');
      }
    } catch (e) {
      log('Errore durante il login: $e');
    }
    return null;
  }

  Map<String, dynamic> parseResponse(String responseBody) {
    return {};
  }
}
