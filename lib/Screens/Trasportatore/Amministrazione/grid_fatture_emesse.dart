import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/details_trasporto_eseguito.dart';

class GridFattureEmesse extends StatefulWidget {
  final List<dynamic> fattureEmesse;
  GridFattureEmesse({Key? key, required this.fattureEmesse}) : super(key: key);

  @override
  _GridFattureEmesseState createState() => _GridFattureEmesseState();
}

class _GridFattureEmesseState extends State<GridFattureEmesse> {

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
                'Fatture Emesse',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Ordine')),
                    DataColumn(label: Text('Cliente')),
                    DataColumn(label: Text('Data')),
                    DataColumn(label: Text('Importo')),
                    DataColumn(label: Text('Stato')),
                    DataColumn(label: Text('Azioni')),
                  ],
                  rows: widget.fattureEmesse.map((fattura) {
                    return DataRow(cells: [
                      DataCell(Text(fattura['id'] ?? '')),
                      DataCell(Text(fattura['cliente'] ?? '')),
                      DataCell(Text(fattura['data'] ?? '')),
                      DataCell(Text(fattura['importo'] ?? '')),
                      DataCell(Text(fattura['stato'] ?? '')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check_circle_outline, color: Colors.orange.shade700),
                            onPressed: () {
                              // Azione per vedere conferma (puoi aggiungere una logica specifica)
                            },
                            tooltip: 'Vedi Conferma',
                          ),
                          IconButton(
                            icon: Icon(Icons.info_outline, color: Colors.orange.shade600),
                            onPressed: () {
                              // Azione per mostrare i dettagli della fattura
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransportoEseguitioDetailPage(
                                    id: fattura['id'] ?? '',
                                    tipoTrasporto: fattura['tipo'] ?? '',
                                    distanza: fattura['distanza'] ?? '',
                                    tempo: fattura['tempo'] ?? '',
                                    localitaRitiro: fattura['localitaRitiro'] ?? '',
                                    dataRitiro: fattura['dataRitiro'] ?? '',
                                    localitaConsegna: fattura['localitaConsegna'] ?? '',
                                    dataConsegna: fattura['dataConsegna'] ?? '',
                                    mezziAllestimenti: fattura['mezziAllestimenti'] ?? '',
                                    ulterioriSpecifiche: fattura['ulterioriSpecifiche'] ?? '',
                                    dettagliMerce: fattura['dettagliMerce'] != null
                                        ? List<Map<String, String>>.from(fattura['dettagliMerce'] as Iterable)
                                        : [],
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
