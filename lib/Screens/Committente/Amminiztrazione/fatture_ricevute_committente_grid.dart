import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/Amministrazione/fattura_details_page.dart';

class GridFattureRicevuteCommittente extends StatefulWidget {
  final List<dynamic> fattureRicevute;
  GridFattureRicevuteCommittente({Key? key, required this.fattureRicevute}) : super(key: key);

  @override
  _GridFattureRicevuteCommittenteState createState() => _GridFattureRicevuteCommittenteState();
}

class _GridFattureRicevuteCommittenteState extends State<GridFattureRicevuteCommittente> {

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
                'Fatture Ricevute',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Data')),
                    DataColumn(label: Text('Ricevuta da')),
                    DataColumn(label: Text('Importo')),
                    DataColumn(label: Text('Descrizione')),
                    DataColumn(label: Text('Info Scadenza')),
                    DataColumn(label: Text('Azioni')),
                  ],
                  rows: widget.fattureRicevute.map((fattura) {
                    return DataRow(cells: [
                      DataCell(Text(fattura['id'] ?? '')),
                      DataCell(Text(fattura['data'] ?? '')),
                      DataCell(Text(fattura['ricevutaDa'] ?? '')),
                      DataCell(Text(fattura['importo'] ?? '')),
                      DataCell(Text(fattura['descrizione'] ?? '')),
                      DataCell(Text(fattura['infoScadenza'] ?? '')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.info_outline, color: Colors.blue.shade600),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FatturaDetailPage(
                                    id: fattura['id'] ?? '',
                                    data: fattura['data'] ?? '',
                                    ricevutaDa: fattura['ricevutaDa'] ?? '',
                                    importo: fattura['importo'] ?? '',
                                    descrizione: fattura['descrizione'] ?? '',
                                    infoScadenza: fattura['infoScadenza'] ?? '',
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
