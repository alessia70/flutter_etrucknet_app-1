import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/details_trasporto_eseguito.dart';

class GridPreventiviAssegnati extends StatefulWidget {
  final List<dynamic> completedTransports;
  const GridPreventiviAssegnati({super.key, required this.completedTransports});

  @override
  _GridPreventiviAssegnatiState createState() => _GridPreventiviAssegnatiState();
}

class _GridPreventiviAssegnatiState extends State<GridPreventiviAssegnati> {

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
                      DataCell(Text(transport['operatore'] ?? '')),
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
                                    id: int.tryParse(['id'].toString()) ?? 0,
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
