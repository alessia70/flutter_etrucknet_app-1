import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/change_stima_to_order.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/dettagli_stima_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/modifica_stima_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';

class DataGridStime extends StatefulWidget {
  const DataGridStime({super.key, required this.onUpdateVisibleEstimates});
  final Function(List<dynamic>) onUpdateVisibleEstimates;

  @override
  DataGridStimeState createState() => DataGridStimeState();
}

class DataGridStimeState extends State<DataGridStime> {
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
      log('Token o TrasportatoreId non trovato.');
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
          log("Nessuna proposta trovata.");
          return;
        }
        setState(() {
          trucks = List<Map<String, dynamic>>.from(
            data.map((item) => {
              'id': item['ordineId'].toString(),
              'carico': item['carico'] ?? '',
              'scarico': item['scarico'] ?? '',
              'stimato': item['idproposta'] ?? '',
              'data': item['dataOrdine'] ?? '',
            }),
          );
          filteredTrucks = List.from(trucks);
        });
      } catch (e) {
        log('Errore nel parsing dei dati: $e');
      }
    } else {
      log('Errore nella richiesta: ${response.statusCode}');
    }
  }

  Future<void> _showPDF(int ordineId, int trasportatoreId) async {
    final token = await getSavedToken();
    if (token == null) {
      log('Token non trovato');
      return;
    }

    final url = Uri.parse(
      'https://etrucknetapi.azurewebsites.net/Proposte/$trasportatoreId',
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
        final filePath = '${tempDir.path}/Stima_${ordineId}_$trasportatoreId.pdf';
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        await OpenFilex.open(filePath);
      } catch (e) {
        log('Errore durante il salvataggio o apertura del PDF: $e');
      }
    } else {
      log('Errore nella richiesta: ${response.statusCode}');
      log('Messaggio: ${response.body}');
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
              log('Tapped on ${estimate['carico']}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stima ${estimate['id']}',
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
                Text('Stimato: ${estimate['idProposta'] ?? "N/A"}'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, color: Colors.orange.shade700),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModificaStimaScreen(estimate: estimate,),
                          ),
                        );
                      },
                      tooltip: 'Modifica',
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.orange.shade600),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DettaglioStimaScreen(estimate: estimate),
                          ),
                        );
                      },
                      tooltip: 'Mostra Dettagli',
                    ),
                    IconButton(
                      icon: Icon(Icons.picture_as_pdf, color: Colors.orange.shade600),
                      onPressed: () async {
                        final ordineId = int.tryParse(estimate['ordineId'] ?? '0') ?? 0;
                        final trasportatoreId = await getSavedUserId() ?? 0;
                        if (ordineId > 0 && trasportatoreId > 0) {
                          _showPDF(ordineId, trasportatoreId);
                        } else {
                          log("ID Stima o Shipper non valido.");
                        }
                      },
                      tooltip: 'Mostra PDF',
                    ),
                    IconButton(
                      icon: Icon(Icons.local_shipping_outlined, color: Colors.orange.shade600),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeStimaToOrder(stimaMerceList: [], stimaTransportType: '',
                            ),
                          ),
                        );
                      },
                      tooltip: 'Converti in ordine',
                    ),
                    IconButton(
                      icon: Icon(Icons.share_outlined, color: Colors.orange.shade600),
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
