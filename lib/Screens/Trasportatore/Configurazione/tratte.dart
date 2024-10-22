import 'package:flutter/material.dart';

class TrattePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tratte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 16),
            _buildTratteTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Cerca tratte',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.add, color: Colors.orange),
          onPressed: () {
            // Logica per aggiungere una nuova tratta
          },
        ),
        IconButton(
          icon: Icon(Icons.filter_list, color: Colors.grey),
          onPressed: () {
            // Logica per filtrare le tratte
          },
        ),
      ],
    );
  }

  Widget _buildTratteTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tabella delle Tratte',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Partenze')),
                  DataColumn(label: Text('Direzione')),
                  DataColumn(label: Text('Arrivi')),
                  DataColumn(label: Text('Automezzi')),
                  DataColumn(label: Text('Servizi')),
                  DataColumn(label: Text('Azioni')),
                ],
                rows: [
                  _buildDataRow('Milano', 'Roma', '12:00', 'Camion 1', 'Servizio A'),
                  _buildDataRow('Torino', 'Napoli', '14:00', 'Camion 2', 'Servizio B'),
                  // Aggiungi altre righe come necessario
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String partenza, String direzione, String arrivo, String automezzo, String servizio) {
    return DataRow(cells: [
      DataCell(Text(partenza)),
      DataCell(Text(direzione)),
      DataCell(Text(arrivo)),
      DataCell(Text(automezzo)),
      DataCell(Text(servizio)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              // Logica per modificare la tratta
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Logica per eliminare la tratta
            },
          ),
        ],
      )),
    ]);
  }
}
