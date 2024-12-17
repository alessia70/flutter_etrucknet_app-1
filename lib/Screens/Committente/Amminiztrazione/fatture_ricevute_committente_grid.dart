import 'dart:convert';
import 'package:flutter_etrucknet_new/Models/ddt_model.dart';
import 'package:flutter_etrucknet_new/Widgets/generate_ddt.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/fatture_ricevute_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridFattureRicevuteCommittente extends StatefulWidget {
  final int trasportatoreId;
  final int numeroDdt;
  final DateTime startDate;
  final DateTime endDate;
  final int stato;

  GridFattureRicevuteCommittente({
    Key? key,
    required this.trasportatoreId,
    required this.numeroDdt,
    required this.startDate,
    required this.endDate,
    required this.stato,
  }) : super(key: key);

  @override
  _GridFattureRicevuteCommittenteState createState() => _GridFattureRicevuteCommittenteState();
}

class _GridFattureRicevuteCommittenteState extends State<GridFattureRicevuteCommittente> {
  late Future<List<FatturaRicevuta>> futureFatture;

  late DDTModel ddt;

  @override
  void initState() {
    super.initState();
    futureFatture = fetchFattureRicevuteCommittente(
      widget.startDate,
      widget.endDate,
      widget.stato,
    );
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('trasportatore_id');
  }

  Future<List<FatturaRicevuta>> fetchFattureRicevuteCommittente(
    DateTime startDate,
    DateTime endDate,
    int stato,
  ) async {
    final token = await getSavedToken();
    final trasportatoreId = await getSavedUserId();

    if (token == null) {
      throw Exception('Token non trovato. Utente non autenticato.');
    }

    final startDateFormatted = "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
    final endDateFormatted = "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

    final url = Uri.parse(
      'https://etrucknetapi.azurewebsites.net/v1/FattureRicevute?StartDate=${startDateFormatted}&EndDate=${endDateFormatted}&Stato=$stato&TrasportatoreId=$trasportatoreId',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => FatturaRicevuta.fromJson(json)).toList();
    } else {
      print('Errore: ${response.statusCode}');
      print('Dettaglio risposta: ${response.body}');
      throw Exception('Failed to load fatture ricevute');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<FatturaRicevuta>>(
          future: futureFatture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Errore: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Nessuna fattura ricevuta trovata.'));
            } else {
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final fattura = snapshot.data![index];
                  return SizedBox(
                    height: 220,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Numero: ${fattura.idFattura}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: Icon(
                                Icons.receipt_long,
                                size: 60,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Fornitore: ${fattura.ricevutaDa ?? 'Non specificato'}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Importo: ${fattura.importo.toString()}",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Data: ${fattura.data.toIso8601String()}",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.euro_outlined, color: Colors.grey),
                                  onPressed: () {
                                  
                                  },
                                  tooltip: 'Pagamenti',
                                ),
                                IconButton(
                                  icon: Icon(Icons.picture_as_pdf_outlined, color: Colors.orange),
                                  onPressed: () async {
                                    /*final committenteId = await getSavedUserId() ?? 0;
                                    if (int.tryParse(id) != null && committenteId > 0) {
                                      _showPDF(id, committenteId);
                                    } else {
                                      print("ID Simulazione o Committente non valido.");
                                    }*/
                                  },
                                  tooltip: 'Vedi Fattura',
                                ),
                                IconButton(
                                  icon: Icon(Icons.send_and_archive_outlined, color: Colors.grey),
                                  onPressed: () {
                                    generateDDT(ddt);
                                  },
                                  tooltip: 'Mostra DDT',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}