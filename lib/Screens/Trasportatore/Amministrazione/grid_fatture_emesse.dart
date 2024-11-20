import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_etrucknet_new/Models/fatture_emesse_model.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/details_trasporto_eseguito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridFattureEmesse extends StatefulWidget {
  final int trasportatoreId;
  final DateTime startDate;
  final DateTime endDate;
  final int stato;

  GridFattureEmesse({
    Key? key,
    required this.trasportatoreId,
    required this.startDate,
    required this.endDate,
    required this.stato,
  }) : super(key: key);

  @override
  _GridFattureEmesseState createState() => _GridFattureEmesseState();
}

class _GridFattureEmesseState extends State<GridFattureEmesse> {
  late Future<List<FatturaEmessa>> futureFatture;

  @override
  void initState() {
    super.initState();
    futureFatture = fetchFattureEmesse(
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

  Future<List<FatturaEmessa>> fetchFattureEmesse(
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

    print("StartDate: $startDateFormatted");
    print("EndDate: $endDateFormatted");
    print("Stato: $stato");
    print("TrasportatoreId: $trasportatoreId");

    final url = Uri.parse(
      'https://etrucknetapi.azurewebsites.net/v1/FattureEmesse?StartDate=${startDateFormatted}&EndDate=${endDateFormatted}&Stato=$stato&TrasportatoreId=$trasportatoreId',
    );
    print('URL della richiesta: $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => FatturaEmessa.fromJson(json)).toList();
    } else {
      print('Errore: ${response.statusCode}');
      print('Dettaglio risposta: ${response.body}');
      throw Exception('Failed to load fatture');
    }
  }

  @override
   Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fatture Emesse',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<FatturaEmessa>>(
                  future: futureFatture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Errore: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Nessuna fattura trovata.'));
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 16.0,
                            columns: [
                              DataColumn(label: Text('Ordine')),
                              DataColumn(label: Text('Cliente')),
                              DataColumn(label: Text('Data')),
                              DataColumn(label: Text('Importo')),
                              DataColumn(label: Text('Stato')),
                              DataColumn(label: Text('Azioni')),
                            ],
                            rows: snapshot.data!.map((fattura) {
                              return DataRow(cells: [
                                DataCell(Text(fattura.id.toString())),
                                DataCell(Text(fattura.ragioneSociale)),
                                DataCell(Text(fattura.dataFattura.toIso8601String())),
                                DataCell(Text(fattura.importo.toString())),
                                DataCell(Text(fattura.stato.toString())),
                                DataCell(Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.check_circle_outline, color: Colors.orange.shade700),
                                      onPressed: () {
                                        // Azione per il pulsante
                                      },
                                      tooltip: 'Vedi Conferma',
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.info_outline, color: Colors.orange.shade600),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TransportoEseguitioDetailPage(
                                              id: fattura.id, tipoTrasporto: '', distanza: '', tempo: '', localitaRitiro: '', dataRitiro: '', localitaConsegna: '', dataConsegna: '', mezziAllestimenti: '', ulterioriSpecifiche: '', dettagliMerce: [], dettagliTrasporto: [],
                                            ),
                                          ),
                                        );
                                      },
                                      tooltip: 'Mostra Dettagli',
                                    ),
                                  ],
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}