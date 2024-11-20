import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/transport_model.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/details_trasporto_eseguito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TotaleTrasportiGrid extends StatefulWidget {
  final List<dynamic> totTrasporti;
  TotaleTrasportiGrid({Key? key, required this.totTrasporti,}) : super(key: key);

  @override
  _TotaleTrasportiGridState createState() => _TotaleTrasportiGridState();
}

class _TotaleTrasportiGridState extends State<TotaleTrasportiGrid> {
  int _selectedStar = 0;
  int trasportatoreId = 0;
  late List<Transport> rdtEseguiti= [];

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
      final url = Uri.parse(
          'https://etrucknetapi.azurewebsites.net/v1/RdtEseguiti?TrasportatoreId=$trasportatoreId&StartDate=2023-01-01');

      print('URL della richiesta: $url');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Risposta HTTP: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> transportsData = data['data'];

        print('Dati ricevuti: $transportsData');

        DateTime? maxEndDate;
        for (var transport in transportsData) {
          final endDateString = transport['dataConsegna'];
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

        setState(() {
          rdtEseguiti = transportsData.map((item) => Transport.fromJson(item)).toList();
        });
      } else {
        print('Errore nell\'API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Errore durante la chiamata API: $e');
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
                'Totale Trasporti',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Ordine')),
                    DataColumn(label: Text('Carico')),
                    DataColumn(label: Text('Scarico')),
                    DataColumn(label: Text('Numero Fattura')),
                    DataColumn(label: Text('Importo Fattura')),
                    DataColumn(label: Text('Data Fattura')),
                    DataColumn(label: Text('Data Scadenza')),
                    DataColumn(label: Text('Azioni')),
                  ],
                  rows: widget.totTrasporti.map((transport) {
                    return DataRow(cells: [
                      DataCell(Text(transport['id'] ?? '')),
                      DataCell(Text(transport['localitaRitiro'] ?? '')),
                      DataCell(Text(transport['localitaConsegna'] ?? '')),
                      DataCell(Text(transport['dataRitiro'] ?? '')),
                      DataCell(Text(transport['dataConsegna'] ?? '')),
                      DataCell(Text(transport['tipo'] ?? '')),
                      DataCell(Text(transport['scandenza'] ?? '')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check_circle_outline, color: Colors.orange.shade700),
                            onPressed: () {

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
                                      id: transport['id'] ?? '',
                                      tipoTrasporto: transport['tipo'] ?? '',
                                      distanza: transport['distanza'] ?? '',
                                      tempo: transport['tempo'] ?? '',
                                      localitaRitiro: transport['localitaRitiro'] ?? '',
                                      dataRitiro: transport['dataRitiro'] ?? '',
                                      localitaConsegna: transport['localitaConsegna'] ?? '',
                                      dataConsegna: transport['dataConsegna'] ?? '',
                                      mezziAllestimenti: transport['mezziAllestimenti'] ?? '',
                                      ulterioriSpecifiche: transport['ulterioriSpecifiche'] ?? '',
                                      dettagliTrasporto: transport['dettagliTrasporto'] != null
                                          ? List<Map<String, String>>.from(transport['dettagliTrasporto'] as Iterable)
                                          : [], dettagliMerce: [],
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
                        child: Text('Data Inserimento', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Gestione', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Nome Committente'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('12345'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('01/01/2024'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('02/01/2024'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Gestione X'),
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
                Navigator.of(context).pop();
              },
              child: Text(
                'Chiudi',
                style: TextStyle(color: Colors.grey),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('Aggiungi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
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
          title: Text('Notifica Targa Trasporto N. $transportId'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Targa trattore/motrice: Selezionare la targa o clicca su Carica Automezzi per inserirne una nuova.'),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Targa',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text('Targa rimorchio/semirimorchio: Selezionare la targa o clicca su Carica Rimorchi per inserirne una nuova.'),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Targa',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text('Autista: Selezionare l’autista o clicca su Carica autisti per inserirne uno nuovo.'),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Autista',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Chiudi',
                style: TextStyle(color: Colors.grey),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Salva'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
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
          title: Text('Dettagli Feedback Trasporto N. $transportId'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Clicca sulle stelle a seconda di quanto sei soddisfatto:'),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _selectedStar ? Icons.star : Icons.star_border,
                        color: index < _selectedStar ? Colors.orangeAccent : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_selectedStar == index + 1) {
                            _selectedStar = 0;
                          } else {
                            _selectedStar = index + 1;
                          }
                        });
                      },
                    );
                  }),
                ),
                SizedBox(height: 16),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Ulteriori informazioni',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Chiudi',
                style: TextStyle(color: Colors.grey),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {

                Navigator.of(context).pop(); 
              },
              child: Text('Salva'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
