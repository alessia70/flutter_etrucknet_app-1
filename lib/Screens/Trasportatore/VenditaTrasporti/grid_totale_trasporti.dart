import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/transport_model.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/details_trasporto_eseguito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TotaleTrasportiGrid extends StatefulWidget {
  final List<Transport> totTrasporti;
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
      final trasportatoreId = this.trasportatoreId;
      final url = Uri.parse(
          'https://etrucknetapi.azurewebsites.net/v1/Proposte/$trasportatoreId');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['data'] != null && jsonResponse['data'] is List) {
          List<dynamic> data = jsonResponse['data'];

          setState(() {
            rdtEseguiti = data.map((item) {
              print(item); 
              return Transport.fromJson(item as Map<String, dynamic>);
            }).toList();
          });
        } else {
          print('Nessun trasporto trovato.');
        }
      } else {
        print('Errore nell\'API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Errore durante la chiamata API: $e');
    }
  }

  Future<void> deleteTransport(int transportId) async {
    try {
      final token = await getSavedToken();
      if (token == null) {
        print('Errore: token non trovato');
        return;
      }
      final url = Uri.parse('https://etrucknetapi.azurewebsites.net/v1/Proposte/$trasportatoreId/$transportId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 204) {
        print('Trasporto eliminato con successo');
        _fetchTransports(token);
      } else {
        print('Errore nell\'eliminazione del trasporto: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante la cancellazione del trasporto: $e');
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
                      rows: rdtEseguiti.map((transport) {
                        return DataRow(cells: [
                          DataCell(Text(transport.ordineId.toString())),
                          DataCell(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(transport.carico ?? ''),
                              Text(DateFormat('dd/MM/yyyy').format(transport.dataInizio)),
                            ],
                          )),
                          DataCell(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(transport.scarico ?? ''),
                              Text(DateFormat('dd/MM/yyyy').format(transport.dataFine)),
                            ],
                          )),
                          DataCell(Text(getEsitoString(transport.esito ?? 0))),
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
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  deleteTransport(transport.idProposta);
                                },
                                tooltip: 'Elimina Trasporto',
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
}