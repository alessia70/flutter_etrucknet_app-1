import 'dart:convert';
import 'package:flutter_etrucknet_new/Models/allestimento_model.dart';
import 'package:http/http.dart' as http;

class TipoAllestimentoService {
  static const String baseUrl = 'https://etrucknetapi.azurewebsites.net/v1/configuration/tipiallestimenti';

  Future<List<Allestimento>> fetchTipoAllestimenti() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Allestimento.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load tipo allestimento');
      }
    } catch (e) {
      throw Exception('Failed to load tipo allestimento: $e');
    }
  }
}
