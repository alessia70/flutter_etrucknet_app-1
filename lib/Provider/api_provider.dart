import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiProvider extends ChangeNotifier {
  final String baseUrl;
  String? token;

  ApiProvider({required this.baseUrl, this.token});
  
  Object? get body => null;

  void setToken(String token) {
    token = token;
    notifyListeners();
  }
  Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final headers = _builderHeaders();

    return http.get(uri, headers: headers);
  }

  Future<http.Response> post(String endpoint, bool contentJson,
      {dynamic body}) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final headers = _builderHeaders(contentJson: contentJson);

    return http.post(uri, headers: headers, body: body);
  }

  Future<http.Response> getWithToken(String endpoint, String token) {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final headers = _builderHeaders(withToken: true, token: token);
    return http.get(uri, headers: headers);
  }

  Future<http.Response> postWithToken(
      String endpoint, String token, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final headers =
        _builderHeaders(withToken: true, contentJson: true, token: token);

    final response = await http.post(uri, headers: headers, body: json.encode(body));

    return response;
  }

  Future<http.Response> putWithToken(
      String endpoint, String token, String body) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final headers =
    _builderHeaders(withToken: true, contentJson: true, token: token);

    final response = await http.put(uri, headers: headers, body: json.encode(body));

    return response;
  }

  Future<http.Response> deleteWithToken(String endPoint, String token) async {
    final uri = Uri.parse('$baseUrl/$endPoint');
    _builderHeaders(withToken: true, contentJson: false, token: token);

    final response = await http.delete(uri);

    return response;
  }
  
  Map<String, String> _builderHeaders(
      {bool withToken = false, bool contentJson = false, String? token}) {
    Map<String, String> headers = {};
    if (contentJson) {
      headers = <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
    } else {
      headers = <String, String>{
        'Context-Type': 'multipart/form-data',
        'Accept': 'application/json'
      };
    }

    if (withToken && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
