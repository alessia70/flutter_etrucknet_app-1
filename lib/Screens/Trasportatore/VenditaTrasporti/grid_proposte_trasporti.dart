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
      final trasportatoreId = await getSavedUserId(); // Recupera l'ID
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
      final response = await http.get(
        Uri.parse('https://etrucknetapi.azurewebsites.net/v1/Proposte/$trasportatoreId?inviato=true'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> transportsData = data['data'];

        print('Dati ricevuti: $transportsData');

        setState(() {
          transports = transportsData.map((item) => Transport.fromJson(item)).toList();
        });
      } else {
        print('Errore nell\'API: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante la chiamata API: $e');
    }
  }

  void _deleteTransport(Transport transport) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conferma Eliminazione'),
          content: Text('Sei sicuro di voler eliminare il trasporto ${transport.id}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  transports.remove(transport);
                });
                Navigator.of(context).pop();
              },
              child: Text('Elimina'),
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
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
  DataRow _buildDataRow(Transport transport) {
    print('Costruzione riga per: ${transport.id}');
    return DataRow(cells: [
      DataCell(Text(transport.id.toString())),
      DataCell(Text(transport.contattoTrasportatore)),
      DataCell(Text(transport.carico)),
      DataCell(Text(DateFormat.yMd().format(transport.dataCarico))),
      DataCell(Text(transport.scarico)),
      DataCell(Text(DateFormat.yMd().format(transport.dataScarico))),
      DataCell(Text(transport.status)),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransportDetailPage(
                    id: transport.id.toString(),
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
            onPressed: () {
              _deleteTransport(transport);
            },
          ),
        ],
      )),
    ]);
  }
}
