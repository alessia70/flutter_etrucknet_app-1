import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/transport_model.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/details_trasporto_proposto.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TrasportiGrid extends StatefulWidget {
  const TrasportiGrid({Key? key}) : super(key: key);

  @override
  _TrasportiGridState createState() => _TrasportiGridState();
}

class _TrasportiGridState extends State<TrasportiGrid> {
  late List<Transport> transports = [];
  int trasportatoreId = 0;

  DateTime? dataInizio;
  DateTime? dataFine;
  double? latitudineCarico;
  double? longitudineCarico;
  double? latitudineScarico;
  double? longitudineScarico;
  int? tolleranza;
  String? allestimento;

  List<Map<String, String>> veicoliFiltrati = [];

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
  String getEsitoString(int esito) {
    switch (esito) {
      case 1:
        return 'Da quotare';
      case 2:
        return 'Quotazione in corso';
      case 3:
        return 'Quotazione scaduta';
      default:
        return 'Sconosciuto';
    }
  }
  Future<void> _fetchTransports(String token) async {
    try {
      final url = Uri.parse('https://etrucknetapi.azurewebsites.net/v1/Proposte/$trasportatoreId?inviato=true');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> transportsData = data['data'];

        setState(() {
          transports = transportsData.map((item) => Transport.fromJson(item)).toList();
          veicoliFiltrati = List.from(transports);
        });
      } else {
        print('Errore nell\'API: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante la chiamata API: $e');
    }
  }

  Future<void> _deleteTransport(String token, Transport transport) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conferma Eliminazione'),
          content: Text('Sei sicuro di voler eliminare il trasporto ${transport.ordineId}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annulla'),
            ),
            TextButton(
              onPressed: () async {
                final url = Uri.parse('https://etrucknetapi.azurewebsites.net/v1/Trasporti/${transport.ordineId}');
                final response = await http.delete(
                  url,
                  headers: {
                    'Authorization': 'Bearer $token',
                  },
                );

                if (response.statusCode == 200) {
                  setState(() {
                    transports.removeWhere((item) => item.ordineId == transport.ordineId);
                  });
                  Navigator.of(context).pop();
                } else {
                  print('Errore nell\'eliminazione: ${response.statusCode}');
                  Navigator.of(context).pop();
                  _showErrorMessage();
                }
              },
              child: Text('Elimina'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Errore'),
          content: Text('Si è verificato un errore nell\'eliminazione del trasporto.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: veicoliFiltrati.length,
                itemBuilder: (context, index) {
                  final veicolo = veicoliFiltrati[index];
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
                              veicolo['tipo'] ?? 'Tipo non disponibile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: Icon(
                                Icons.local_shipping,
                                size: 60,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Allestimento: ${veicolo['Ordine'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Allestimento: ${veicolo['Contatto Trasportatore'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Allestimento: ${veicolo['Luogo Carico'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Allestimento: ${veicolo['Data Carico'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Allestimento: ${veicolo['Luogo Scarico'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Specifiche: ${veicolo['Data Scarico'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () => _showEditTruckDialog(context, veicolo),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.grey),
                                  onPressed: () => _showDeleteConfirmationDialog(context, veicolo),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  );
                },
              ),
            ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Ordine')),
                        DataColumn(label: Text('Contatto Trasportatore')),
                        DataColumn(label: Text('Luogo Carico')),
                        DataColumn(label: Text('Data Carico')),
                        DataColumn(label: Text('Luogo Scarico')),
                        DataColumn(label: Text('Data Scarico')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Azioni')),
                      ],
                      rows: transports.map((transport) => _buildDataRow(transport)).toList(),
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

  void _showEditTruckDialog(BuildContext context, Map<String, String> veicolo) {
    TextEditingController nameController = TextEditingController(text: veicolo['name'] ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Modifica Veicolo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nome Veicolo",
                  hintText: "Inserisci il nuovo nome",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annulla"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  veicolo['name'] = nameController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text("Salva"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Map<String, String> veicolo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conferma'),
          content: Text('Sei sicuro di voler eliminare questo veicolo?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  transports.remove(veicolo);
                  veicoliFiltrati = List.from(transports);
                });
                Navigator.of(context).pop();
              },
              child: Text('Sì'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annulla'),
            ),
          ],
        );
      },
    );
  }
  DataRow _buildDataRow(Transport transport) {
    return DataRow(cells: [
      DataCell(Text(transport.ordineId.toString())),
      DataCell(Text(transport.contattoTrasportatore)),
      DataCell(Text(transport.carico)),
      DataCell(Text(DateFormat.yMd().format(transport.dataCarico))),
      DataCell(Text(transport.scarico)),
      DataCell(Text(DateFormat.yMd().format(transport.dataScarico))),
      DataCell(Text(getEsitoString(transport.esito))),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransportDetailPage(
                    id: transport.ordineId.toString(),
                    tipoTrasporto: transport.tipoTrasporto,
                    distanza: "581 Km",
                    tempo: "6 ore 53 minuti",
                    localitaRitiro: transport.luogoCarico,
                    dataRitiro: DateFormat.yMd().format(transport.dataCarico),
                    localitaConsegna: transport.luogoScarico,
                    dataConsegna: DateFormat.yMd().format(transport.dataScarico),
                    mezziAllestimenti: "Centinato telonato - Gran volume centinato",
                    ulterioriSpecifiche: "Richiesta solo offerta. Grazie",
                    dettagliMerce: [
                      {
                        'qta': '1',
                        'tipo': 'cassa',
                        'dimensioni': '65 X 400',
                        'altezza': '45',
                        'peso': '245',
                      }
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.grey),
            onPressed: () async {
              final token = await getSavedToken();
              
              if (token != null) {
                _deleteTransport(token, transport);
              } else {
                print("Token non trovato");
              }
            },
          ),
        ],
      )),
    ]);
  }
}
