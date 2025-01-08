import 'dart:convert';
import 'package:flutter_etrucknet_new/Models/specifiche_model.dart';
import 'package:http/http.dart' as http;

class TipiSpecificheService {
  static const String baseUrl = 'https://etrucknetapi.azurewebsites.net/v1/configuration/tipispecifiche';

  Future<List<Specifica>> fetchSpecifiche() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Specifica.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load tipo specifiche');
      }
    } catch (e) {
      throw Exception('Failed to load tipo specifiche: $e');
    }
  }
}
