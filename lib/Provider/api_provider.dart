import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiProvider extends ChangeNotifier {
  final String baseUrl;
  String? token;

  ApiProvider({required this.baseUrl, this.token});
  
  Object? get body => null;

  void setToken(String newToken) {
    token = newToken;
    notifyListeners();
  }

  Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final headers = _builderHeaders();

    return http.get(uri, headers: headers);
  }

  Future<http.Response> post(String endpoint, Map<String, String> data) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final headers = _builderHeaders(isJsonFormat: false);

    // Usa FormData per il body
    return http.post(uri, headers: headers, body: data);
  }

  Future<http.Response> getWithToken(String endpoint, String token) {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final headers = _builderHeaders(withToken: true, token: token);
    return http.get(uri, headers: headers);
  }

  Future<http.Response> postWithToken(String endpoint, String token, Map<String, String> data) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final headers = _builderHeaders(withToken: true, isJsonFormat: false, token: token); // Imposta isJsonFormat a false

    // Usa FormData per il body
    final response = await http.post(uri, headers: headers, body: data);

    return response;
  }

  Future<http.Response> putWithToken(String endpoint, String token, Map<String, String> data) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final headers = _builderHeaders(withToken: true, isJsonFormat: false, token: token); // Imposta isJsonFormat a false

    // Usa FormData per il body
    final response = await http.put(uri, headers: headers, body: data);

    return response;
  }

  Future<http.Response> deleteWithToken(String endPoint, String token) async {
    final uri = Uri.parse('$baseUrl/$endPoint');
    final headers = _builderHeaders(withToken: true, isJsonFormat: false, token: token); // Imposta isJsonFormat a false

    final response = await http.delete(uri, headers: headers); // Assicurati di passare i headers

    return response;
  }

  Map<String, String> _builderHeaders({bool withToken = false, bool isJsonFormat = false, String? token}) {
    Map<String, String> headers = {};
    
    // Cambiato per gestire x-www-form-urlencoded
    if (isJsonFormat) {
      headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
    } else {
      headers = <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
      };
    }

    if (withToken && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
