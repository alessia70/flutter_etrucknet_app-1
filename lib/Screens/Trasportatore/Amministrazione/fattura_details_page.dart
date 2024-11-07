import 'package:flutter/material.dart';

class FatturaDetailPage extends StatelessWidget {
  final String id;
  final String data;
  final String ricevutaDa;
  final String importo;
  final String descrizione;
  final String infoScadenza;

  FatturaDetailPage({
    required this.id,
    required this.data,
    required this.ricevutaDa,
    required this.importo,
    required this.descrizione,
    required this.infoScadenza,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettagli Fattura'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: $id', style: TextStyle(fontSize: 16)),
            Text('Data: $data', style: TextStyle(fontSize: 16)),
            Text('Ricevuta da: $ricevutaDa', style: TextStyle(fontSize: 16)),
            Text('Importo: $importo', style: TextStyle(fontSize: 16)),
            Text('Descrizione: $descrizione', style: TextStyle(fontSize: 16)),
            Text('Info Scadenza: $infoScadenza', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
