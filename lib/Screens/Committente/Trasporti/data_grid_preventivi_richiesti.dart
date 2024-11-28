import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/details_trasporto_eseguito.dart';

class GridPreventiviRichiesti extends StatefulWidget {
  final List<dynamic> completedTransports;
  GridPreventiviRichiesti({Key? key, required this.completedTransports}) : super(key: key);

  @override
  _GridPreventiviRichiestiState createState() => _GridPreventiviRichiestiState();
}

class _GridPreventiviRichiestiState extends State<GridPreventiviRichiesti> {

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
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Ordine')),
                    DataColumn(label: Text('Utente')),
                    DataColumn(label: Text('Carico')),
                    DataColumn(label: Text('Scarico')),
                    DataColumn(label: Text('Offerte')),
                    DataColumn(label: Text('Azioni')),
                  ],
                  rows: widget.completedTransports.map((transport) {
                    return DataRow(cells: [
                      DataCell(Text(transport['id'] ?? '')),
                      DataCell(Text(transport['utente'] ?? '')),
                      DataCell(Text(transport['localitaRitiro'] ?? '')),
                      DataCell(Text(transport['localitaConsegna'] ?? '')),
                      DataCell(Text(transport['offerte'] ?? '')),
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
                                    dettagliMerce: transport['dettagliMerce'] != null
                                        ? List<Map<String, String>>.from(transport['dettagliMerce'] as Iterable)
                                        : [], dettagliTrasporto: [],
                                  ),
                                ),
                              );
                            },
                            tooltip: 'Mostra Dettagli',
                          ),
                          IconButton(
                              icon: Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Conferma Eliminazione'),
                                      content: Text('Sei sicuro di voler eliminare questo preventivo?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Annulla'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Elimina'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              tooltip: 'Elimina Preventivo',
                            ),
                            IconButton(
                              icon: Icon(Icons.message_outlined, color: Colors.blue),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Messaggi del Cliente'),
                                      content: Text('Visualizza i messaggi inviati dal cliente.'),
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
                              },
                              tooltip: 'Messaggi Cliente',
                            ),
                            IconButton(
                              icon: Icon(Icons.map_outlined, color: Colors.green),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Mappa non disponibile'),
                                      content: Text('La visualizzazione della mappa non è ancora implementata.'),
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
                                )
                              );
                            },
                            tooltip: 'Visualizza Mappa',
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
}