// ignore_for_file: use_rethrow_when_possible, unused_import

import 'dart:convert';
import 'package:flutter_etrucknet_new/Models/user_model.dart';
import 'package:flutter_etrucknet_new/Services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_etrucknet_new/Provider/api_provider.dart';
import 'package:flutter_etrucknet_new/res/app_urls.dart';

class AuthRepository {
  final ApiProvider apiProvider = ApiProvider(baseUrl: AppUrl.baseUrl);

  // Funzione di login
  Future<UserModel?> loginApi(Map<String, dynamic> data) async {
    try {
      http.Response response = await apiProvider.post(
        AppUrl.loginEndPoint,
        false,
        body: data,
      );

      // Gestione delle risposte dell'API
      if (response.statusCode == 200) {
        var responseUser = jsonDecode(response.body);
        final UserModel user = UserModel.fromJson(responseUser);
        return user;
      } else if (response.statusCode == 401) {
        throw Exception("Username o password errate");
      } else {
        throw Exception("Errore di connessione: ${response.reasonPhrase}");
      }
    } catch (e) {
      // Propaga l'errore
      throw Exception("Errore durante il login: $e");
    }
  }

  // Funzione di registrazione
  Future<dynamic> signupApi(Map<String, dynamic> data) async {
    try {
      dynamic response = await apiProvider.post(
        AppUrl.registerApiEndPoint,
        false,
        body: data,
      );
      return response;
    } catch (e) {
      throw Exception("Errore durante la registrazione: $e");
    }
  }
}
