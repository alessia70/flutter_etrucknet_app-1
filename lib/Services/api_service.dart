import 'dart:convert';
import 'package:flutter_etrucknet_new/DTOs/stima_dto.dart';
import 'package:flutter_etrucknet_new/Models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final List<Stima> _stime = [];
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
  }
  Future<List<Stima>> getStime() async {
    await Future.delayed(Duration(seconds: 1));
    return _stime;
  }
  Future<void> createStima(Map<String, dynamic> stimaData) async {
    await Future.delayed(Duration(seconds: 1));
    _stime.add(Stima.fromJson(stimaData));
  }
  Future<UserModel?> fetchUserData(String s) async {
    String? token = await getToken();
    if (token == null) {
      print('Token non disponibile');
      return null;
    }

    final response = await http.get(
      Uri.parse('https://etrucknetapi.azurewebsites.net/v1/Auth/Login'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromForm(data);
    } else {
      print('Errore nel caricamento dei dati utente');
      return null;
    }
  }
  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://etrucknetapi.azurewebsites.net/v1/Auth/Login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      String token = jsonDecode(response.body)['token'];
      await saveToken(token);
      print('Login avvenuto con successo!');
    } else {
      print('Login fallito');
    }
  }
}
