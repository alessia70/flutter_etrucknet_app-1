import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/details_trasporto_proposto.dart';
import 'package:intl/intl.dart';

class Transport {
  final String id;
  final String tipoTrasporto;
  final String contattoTrasportatore;
  final DateTime dataCarico;
  final String luogoCarico;
  final DateTime dataScarico;
  final String luogoScarico;
  final String status;

  Transport({
    required this.id,
    required this.tipoTrasporto,
    required this.contattoTrasportatore,
    required this.dataCarico,
    required this.luogoCarico,
    required this.dataScarico,
    required this.luogoScarico,
    required this.status,
  });
}

class TrasportiGrid extends StatefulWidget {
  final List<Transport> transports;
  const TrasportiGrid({Key? key, required this.transports}) : super(key: key);

  @override
  _TrasportiGridState createState() => _TrasportiGridState();
}

class _TrasportiGridState extends State<TrasportiGrid> {
  late List<Transport> transports;

  @override
  void initState() {
    super.initState();
    transports = widget.transports;
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
              SingleChildScrollView(
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
                  rows: transports.map((transport) {
                    return _buildDataRow(transport);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(Transport transport) {
    return DataRow(cells: [
      DataCell(Text(transport.id)),
      DataCell(Text(transport.contattoTrasportatore)),
      DataCell(Text(transport.luogoCarico)),
      DataCell(Text(DateFormat.yMd().format(transport.dataCarico))),
      DataCell(Text(transport.luogoScarico)),
      DataCell(Text(DateFormat.yMd().format(transport.dataScarico))),
      DataCell(Text(transport.status)),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.orange),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => TransportDetailPage(
                  id: transport.id,
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
                  ]),
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
