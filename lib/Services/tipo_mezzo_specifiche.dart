import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_etrucknet_new/Models/tipo_mezzo_specifiche_model.dart';

class TipoMezzoSpecificheService {
  final String apiUrl = "https://etrucknetapi.azurewebsites.net/v1/configuration/tipispecifiche";

  Future<List<TipoMezzoSpecifiche>> fetchTipiMezzoSpecifiche() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => TipoMezzoSpecifiche.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load tipologia mezzi specifiche');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}