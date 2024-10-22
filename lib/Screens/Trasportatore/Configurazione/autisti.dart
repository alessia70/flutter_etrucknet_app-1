import 'package:flutter/material.dart';

class AutistiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autisti'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 16),
            _buildAutistiTable(),
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
              labelText: 'Cerca autista',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.add, color: Colors.orange),
          onPressed: () {
            // Logica per aggiungere un nuovo autista
          },
        ),
      ],
    );
  }

  Widget _buildAutistiTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tabella degli Autisti',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Cognome')),
                    DataColumn(label: Text('Nome')),
                    DataColumn(label: Text('Telefono')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Azioni')),
                  ],
                  rows: [
                    _buildDataRow('Rossi', 'Mario', '1234567890', 'mario.rossi@example.com'),
                    _buildDataRow('Bianchi', 'Luigi', '0987654321', 'luigi.bianchi@example.com'),
                    // Aggiungi altre righe come necessario
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String cognome, String nome, String telefono, String email) {
    return DataRow(cells: [
      DataCell(Text(cognome)),
      DataCell(Text(nome)),
      DataCell(Text(telefono)),
      DataCell(Text(email)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              // Logica per modificare i dettagli dell'autista
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Logica per eliminare i dettagli dell'autista
            },
          ),
        ],
      )),
    ]);
  }
}
