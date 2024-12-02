import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/transport_model.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/details_trasporto_eseguito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TotaleTrasportiGrid extends StatefulWidget {
  final List<dynamic> totTrasporti;
  TotaleTrasportiGrid({Key? key, required this.totTrasporti}) : super(key: key);

  @override
  _TotaleTrasportiGridState createState() => _TotaleTrasportiGridState();
}

class _TotaleTrasportiGridState extends State<TotaleTrasportiGrid> {
  int _selectedStar = 0;
  int trasportatoreId = 0;
  late List<Transport> rdtEseguiti = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('trasportatore_id');
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _loadUserData() async {
    try {
      final trasportatoreId = await getSavedUserId();
      final token = await getSavedToken();

      if (trasportatoreId == null || token == null) {
        print('Errore: userId o token non trovato');
        return;
      }

      setState(() {
        this.trasportatoreId = trasportatoreId;
      });
      _fetchTransports(token);
    } catch (e) {
      print('Errore durante il caricamento dei dati utente: $e');
    }
  }

  Future<void> _fetchTransports(String token) async {
    try {
      final trasportatoreId = this.trasportatoreId;
      final startDate = DateTime(2000, 1, 1);

      DateTime endDate = DateTime(2080, 1, 1);
      endDate = DateTime(endDate.year, endDate.month + 1, 1);
      String startDateString = DateFormat('yyyy-MM-dd').format(startDate);
      String endDateString = DateFormat('yyyy-MM-dd').format(endDate);

      final url = Uri.parse(
        'https://etrucknetapi.azurewebsites.net/v1/Proposte/8324?TrasportatoreId=$trasportatoreId'
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] != null && jsonResponse['data'] is List) {
          List<dynamic> data = jsonResponse['data'];

          setState(() {
            rdtEseguiti = data.map((item) => Transport.fromJson(item)).toList();
          });
        } else {
          print('Nessun trasporto trovato.');
        }

        DateTime? maxEndDate;
        for (var transport in jsonResponse['data'] ?? []) {
          final endDateString = transport['dataFine'];
          if (endDateString != null) {
            final endDate = DateTime.tryParse(endDateString);
            if (endDate != null) {
              if (maxEndDate == null || endDate.isAfter(maxEndDate)) {
                maxEndDate = endDate;
              }
            }
          }
        }

        if (maxEndDate != null) {
          print('Data più lontana trovata: $maxEndDate');
        } else {
          print('Nessuna data valida trovata nei dati ricevuti.');
        }
      } else {
        print('Errore nell\'API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Errore durante la chiamata API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.totTrasporti);
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
                'Totale Trasporti',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Ordine')),
                        DataColumn(label: Text('Carico')),
                        DataColumn(label: Text('Scarico')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Azioni')),
                      ],
                      rows: widget.totTrasporti.map((transport) {
                        return DataRow(cells: [
                          DataCell(Text(transport.ordineId.toString() ?? '')),
                          DataCell(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(transport.carico ?? ''),
                              Text(transport.dataInizio.toString() ?? ''),
                            ],
                          )),
                          DataCell(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(transport.scarico ?? ''),
                              Text(transport.dataFine.toString() ?? ''),
                            ],
                          )),
                          DataCell(Text(transport.esito ?? '')),
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check_circle_outline, color: Colors.orange.shade700),
                                onPressed: () {},
                                tooltip: 'Vedi Conferma',
                              ),
                              IconButton(
                                icon: Icon(Icons.info_outline, color: Colors.orange.shade600),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TransportoEseguitioDetailPage(
                                        id: transport.idProposta,
                                        tipoTrasporto: transport.tipoTrasporto,
                                        distanza: transport.distanza ?? '',
                                        tempo: transport.tempo ?? '',
                                        localitaRitiro: transport.localitaRitiro ?? '',
                                        dataRitiro: transport.dataRitiro?.toString() ?? '',
                                        localitaConsegna: transport.localitaConsegna ?? '',
                                        dataConsegna: transport.dataConsegna?.toString() ?? '',
                                        mezziAllestimenti: transport.mezziAllestimenti ?? '',
                                        ulterioriSpecifiche: transport.ulterioriSpecifiche ?? '',
                                        dettagliTrasporto: transport.dettagliTrasporto ?? [],
                                        dettagliMerce: transport.dettagliMerce ?? [],
                                      ),
                                    ),
                                  );
                                },
                                tooltip: 'Mostra Dettagli',
                              ),
                              IconButton(
                                icon: Icon(Icons.picture_as_pdf, color: Colors.orange.shade500),
                                onPressed: () {
                                  _showDDTPopup(context, transport['id'] ?? '');
                                },
                                tooltip: 'Mostra DDT',
                              ),
                              IconButton(
                                icon: Icon(Icons.car_repair, color: Colors.orange.shade400),
                                onPressed: () {
                                  _showCommunicaTargaPopup(context, transport['id'] ?? '');
                                },
                                tooltip: 'Comunica Targa',
                              ),
                              IconButton(
                                icon: Icon(Icons.reviews_outlined, color: Colors.orange.shade300),
                                onPressed: () {
                                  _showFeedbackPopup(context, transport['id'] ?? '');
                                },
                                tooltip: 'Feedbacks',
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDDTPopup(BuildContext context, String transportId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('DDT Trasporto N $transportId'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Table(
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey, width: 0.5),
                ),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Committente', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Numero DDT', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Data DDT', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Stato DDT', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Committente $transportId'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('$transportId'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('2024-11-30'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('In Consegna'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }

  void _showCommunicaTargaPopup(BuildContext context, String transportId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comunica Targa per Trasporto $transportId'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Inserisci la targa del veicolo'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                // Logica per inviare la targa
              },
              child: Text('Invia'),
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackPopup(BuildContext context, String transportId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aggiungi Feedback per Trasporto $transportId'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Inserisci il tuo feedback'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                // Logica per inviare il feedback
              },
              child: Text('Invia'),
            ),
          ],
        );
      },
    );
  }
}
