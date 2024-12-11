import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Simulatore/change_simulazione_toOrder.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Simulatore/dettaglio_simulazione.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Simulatore/modifica_simulazione_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';

class DataGridSimulazioni extends StatefulWidget {
  const DataGridSimulazioni({Key? key, required this.onUpdateVisibleSimulations}) : super(key: key);
  final Function(List<dynamic>) onUpdateVisibleSimulations;

  @override
  DataGridSimulazioniState createState() => DataGridSimulazioniState();
}

class DataGridSimulazioniState extends State<DataGridSimulazioni> {
  List<Map<String, dynamic>> trucks = [];
  List<Map<String, dynamic>> filteredTrucks = [];

  @override
  void initState() {
    super.initState();
    _fetchSimulations();
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

  Future<void> _fetchSimulations() async {
    final token = await getSavedToken();
    final trasportatoreId = await getSavedUserId();

    if (token == null || trasportatoreId == null) {
      print('Token o CommittenteId non trovato.');
      return;
    }

    final url = Uri.parse(
      'https://etrucknetapi.azurewebsites.net/v1/Proposte/$trasportatoreId',
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
          print("Nessuna simulazione trovata.");
          return;
        }
        setState(() {
          trucks = List<Map<String, dynamic>>.from(
            data.map((item) => {
              'id': item['ordineId'].toString(),
              'carico': item['carico'] ?? '',
              'scarico': item['scarico'] ?? '',
              'stimato': item['idSimulazione'] ?? '',
              'data': item['dataOrdine'] ?? '',
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

  Future<void> _showPDF(int ordineId, int trasportatoreId) async {
    final token = await getSavedToken();
    if (token == null) {
      print('Token non trovato');
      return;
    }

    final url = Uri.parse(
      'https://etrucknetapi.azurewebsites.net/Simulazioni/$trasportatoreId',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/Simulazione_${ordineId}_$trasportatoreId.pdf';
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        await OpenFilex.open(filePath);
      } catch (e) {
        print('Errore durante il salvataggio o apertura del PDF: $e');
      }
    } else {
      print('Errore nella richiesta: ${response.statusCode}');
      print('Messaggio: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (trucks.isEmpty) {
      return Center(
        child: Text('Nessuna simulazione disponibile'),
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
          final simulation = trucks[index];
          return GestureDetector(
            onTap: () {
              print('Tapped on ${simulation['carico']}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stima ${simulation['id']}',
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text('Carico: ${simulation['carico']}'),
                Text('Scarico: ${simulation['scarico']}'),
                SizedBox(height: 5),
                Text('Stimato: ${simulation['stimato']}'),
                SizedBox(height: 5),
                Text('Data: ${simulation['data']}'),
                SizedBox(height: 5),
                Text('Stimato: ${simulation['idSimulazione'] ?? "N/A"}'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, color: Colors.orange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModificaSimulazioneScreen(simulation: simulation,),
                          ),
                        );
                      },
                      tooltip: 'Modifica',
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.orange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DettaglioSimulazioneScreen(simulation: simulation),
                          ),
                        );
                      },
                      tooltip: 'Mostra Dettagli',
                    ),
                    IconButton(
                      icon: Icon(Icons.picture_as_pdf, color: Colors.orange),
                      onPressed: () async {
                        final ordineId = int.tryParse(simulation['ordineId'] ?? '0') ?? 0;
                        final committenteId = await getSavedUserId() ?? 0;
                        if (ordineId > 0 && committenteId > 0) {
                          _showPDF(ordineId, committenteId);
                        } else {
                          print("ID Simulazione o Committente non valido.");
                        }
                      },
                      tooltip: 'Mostra PDF',
                    ),
                    IconButton(
                      icon: Icon(Icons.local_shipping_outlined, color: Colors.orange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeSimulazioneToOrder(simulazioneTransportType: '', simulazioneList: [],
                            ),
                          ),
                        );
                      },
                      tooltip: 'Converti in ordine',
                    ),
                    IconButton(
                      icon: Icon(Icons.share_outlined, color: Colors.orange),
                      onPressed: () {
                        //logica per condividere
                      },
                      tooltip: 'Condividi',
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
