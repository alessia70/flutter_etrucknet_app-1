import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DataGridStime extends StatefulWidget {
  const DataGridStime({super.key});

  @override
  _DataGridStimeState createState() => _DataGridStimeState();
}

class _DataGridStimeState extends State<DataGridStime> {
  List<Map<String, dynamic>> trucks = [];
  List<Map<String, dynamic>> filteredTrucks = [];

  @override
  void initState() {
    super.initState();
    _fetchEstimates();
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return token;
  }

  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('trasportatore_id');
  }

  Future<void> _fetchEstimates() async {
    final token = await getSavedToken();
    final trasportatoreId = await getSavedUserId();

    if (token == null || trasportatoreId == null) {
      print('Token o TrasportatoreId non trovato.');
      return;
    }

    final url = Uri.parse(
      'https://etrucknetapi.azurewebsites.net/v1/Proposte/$trasportatoreId'
      '?TrasportatoreId=$trasportatoreId',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final responseData = json.decode(response.body);
        List<dynamic>? data = responseData['data'];
        if (data == null || data.isEmpty) {
          print("Nessuna proposta trovata.");
          return;
        }
        setState(() {
          trucks = List<Map<String, dynamic>>.from(
            data.map((item) => {
              'id': item['id'].toString(),
              'carico': item['carico'] ?? '',
              'scarico': item['scarico'] ?? '',
              'stimato': item['dataOrdine'] ?? '',
              'data': item['dataOrdine'] ?? '',
              'specifiche': item['provinciaCarico'] ?? 'N/A',
            }),
          );
          filteredTrucks = List.from(trucks);
        });
      } catch (e) {
        print('Errore nel parsing dei dati: $e');
      }
    } else {
      print('Errore nella richiesta: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (trucks.isEmpty) {
      return Center(
        child: Text('Nessuna stima disponibile'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 2.0,
        ),
        itemCount: trucks.length,
        itemBuilder: (context, index) {
          final estimate = trucks[index];
          return GestureDetector(
            onTap: () {
              print('Tapped on ${estimate['carico']}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stima ${estimate['ordineId']}',
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text('Carico: ${estimate['carico']}'),
                Text('Scarico: ${estimate['scarico']}'),
                SizedBox(height: 5),
                Text('Stimato: ${estimate['stimato']}'),
                SizedBox(height: 5),
                Text('Data: ${estimate['data']}'),
                SizedBox(height: 5),
                Text('Specifiche: ${estimate['specifiche'] ?? "N/A"}'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check_circle_outline, color: Colors.orange.shade700),
                      onPressed: () {
                        //logica per vedere conferma
                      },
                      tooltip: 'Vedi Conferma',
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.orange.shade600),
                      onPressed: () {
                        //logica per mostrare dettagli
                      },
                      tooltip: 'Mostra Dettagli',
                    ),
                    IconButton(
                      icon: Icon(Icons.drive_file_rename_outline, color: Colors.orange.shade600),
                      onPressed: () {
                        //logica per mostrare DDT
                      },
                      tooltip: 'Mostra DDT',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
