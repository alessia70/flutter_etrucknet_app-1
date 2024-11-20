import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/rdtEseguiti_model.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/details_trasporto_eseguito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransportiEseguitiGrid extends StatefulWidget {
  @override
  _TransportiEseguitiGridState createState() => _TransportiEseguitiGridState();
}

class _TransportiEseguitiGridState extends State<TransportiEseguitiGrid> {
  int trasportatoreId = 0;
  late List<RdtEseguiti> rdtEseguiti = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  String formatDate(dynamic dateInput) {
    if (dateInput == null || dateInput == "0001-01-01T00:00:00") {
      return "N/A";
    }
    try {
      DateTime dateTime;

      if (dateInput is String) {
        dateTime = DateTime.parse(dateInput);
      } else if (dateInput is DateTime) {
        dateTime = dateInput;
      } else {
        throw FormatException("Tipo di dato non supportato");
      }
      return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
    } catch (e) {
      return "Formato Data Non Valido";
    }
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
  }
  Future<String> fetchEndDate(String token) async {
    DateTime currentDate = DateTime.now();
    DateTime futureEndDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);

    String endDate = futureEndDate.toIso8601String().split('T')[0];
    
    return endDate; 
  }

  Future<void> _fetchTransports(String token) async {
    try {
      final endDate = await fetchEndDate(token);
      final url = Uri.parse(
          'https://etrucknetapi.azurewebsites.net/v1/RdtEseguiti?TrasportatoreId=$trasportatoreId&StartDate=1900-01-01&EndDate=$endDate');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          rdtEseguiti = data.map<RdtEseguiti>((item) => RdtEseguiti.fromJson(item)).toList();
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
                'Trasporti Eseguiti',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 16),
               Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Ordine')),
                        DataColumn(label: Text('Carico')),
                        DataColumn(label: Text('dataCarico')),
                        DataColumn(label: Text('Scarico')),
                        DataColumn(label: Text('dataScarico')),
                        DataColumn(label: Text('Numero Fattura')),
                        DataColumn(label: Text('Importo Fattura')),
                        DataColumn(label: Text('Data Fattura')),
                        DataColumn(label: Text('Data Scadenza')),
                        DataColumn(label: Text('Azioni')),
                      ],
                      rows: rdtEseguiti.map((transport) {
                        return DataRow(
                          cells: [
                            DataCell(Text(transport.ordineId.toString())),
                            DataCell(Text(transport.luogoCarico ?? '')), 
                            DataCell(Text(formatDate(transport.dataCarico))),
                            DataCell(Text(transport.luogoScarico ?? '')),
                            DataCell(Text(formatDate(transport.dataScarico))),
                            DataCell(Text(transport.fatturaId != 0 ? transport.fatturaId.toString() : 'N/A')),
                            DataCell(Text(transport.importoFattura.toStringAsFixed(2))),
                            DataCell(Text(transport.dataFattura != "0001-01-01T00:00:00"
                                ? formatDate(transport.dataFattura)
                                : 'N/A')),
                            DataCell(Text(transport.dataScadenza != "0001-01-01T00:00:00"
                                ? formatDate(transport.dataScadenza)
                                : 'N/A')),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check_circle_outline, color: Colors.orange.shade700),
                                  onPressed: () {
                                    // Open PDF here
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
                                          id: transport.id,
                                          tipoTrasporto: transport.luogoCarico.toString(),
                                          distanza: transport.luogoScarico.toString(),
                                          tempo: formatDate(transport.dataCarico),
                                          localitaRitiro: formatDate(transport.dataScarico),
                                          dataRitiro: transport.importoFattura.toString(),
                                          localitaConsegna: transport.dataFattura.toString(),
                                          dataConsegna: transport.dataScadenza.toString(),
                                          dettagliTrasporto: transport.dettagliTrasporto != null
                                              ? List<Map<String, String>>.from(transport.dettagliTrasporto as Iterable)
                                              : [], mezziAllestimenti: '', ulterioriSpecifiche: '', dettagliMerce: [],
                                        ),
                                      ),
                                    );
                                  },
                                  tooltip: 'Mostra Dettagli',
                                ),
                                IconButton(
                                  icon: Icon(Icons.drive_file_rename_outline, color: Colors.orange.shade600),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => DdtPopup(),
                                    );
                                  },
                                  tooltip: 'Mostra DDT',
                                ),
                                IconButton(
                                  icon: Icon(Icons.directions_car, color: Colors.orange.shade600),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => TargaPopup(),
                                    );
                                  },
                                  tooltip: 'Comunicazione Targa',
                                ),
                                IconButton(
                                  icon: Icon(Icons.star_border, color: Colors.orange.shade600),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => FeedbackPopup(),
                                    );
                                  },
                                  tooltip: 'Feedback',
                                ),
                              ],
                            )),
                          ],
                        );
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
}

class DdtPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("DDT - Dettagli Trasporto"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Table(
              children: [
                TableRow(
                  children: [
                    Text('Committente'),
                    Text('Numero DDT'),
                    Text('Data DDT'),
                    Text('Data Inserimento'),
                    Text('Gestione'),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Committente X'),
                    Text('DDT12345'),
                    Text('2023-11-20'),
                    Text('2023-11-20'),
                    Text('Gestione Y'),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text('Chiudi'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add DDT logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text('Aggiungi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TargaPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Comunicazione Targa"),
      content: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Inserisci Targa'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Conferma'),
          ),
        ],
      ),
    );
  }
}

class FeedbackPopup extends StatefulWidget {
  @override
  _FeedbackPopupState createState() => _FeedbackPopupState();
}

class _FeedbackPopupState extends State<FeedbackPopup> {
  int _selectedStars = 0;
  TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Feedback"),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  _selectedStars > index ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                ),
                onPressed: () {
                  setState(() {
                    _selectedStars = index + 1;
                  });
                },
              );
            }),
          ),
          TextField(
            controller: _feedbackController,
            decoration: InputDecoration(labelText: 'Aggiungi un commento'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: Text('Chiudi'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save feedback logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text('Salva'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
