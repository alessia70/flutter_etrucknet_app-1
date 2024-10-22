import 'package:flutter/material.dart';

class CamionDisponibiliTPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camion Disponibili'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 16),
            _buildCamionTable(),
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
              labelText: 'Cerca camion',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.date_range, color: Colors.orange),
          onPressed: () {
            // Logica per filtrare le date
          },
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.add, color: Colors.orange),
          onPressed: () {
            // Logica per aggiungere un nuovo camion disponibile
          },
        ),
      ],
    );
  }

  Widget _buildCamionTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tabella dei Camion Disponibili',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Tipo Mezzo')),
                    DataColumn(label: Text('Allestimento')),
                    DataColumn(label: Text('Spazio Disponibile')),
                    DataColumn(label: Text('Località Carico')),
                    DataColumn(label: Text('Località Scarico')),
                    DataColumn(label: Text('Data Ritiro')),
                    DataColumn(label: Text('Azioni')),
                  ],
                  rows: [
                    _buildDataRow('Camion A', 'Allestimento 1', '10 m³', 'Roma', 'Milano', '2024-10-01'),
                    _buildDataRow('Camion B', 'Allestimento 2', '15 m³', 'Napoli', 'Torino', '2024-10-05'),
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

  DataRow _buildDataRow(String tipoMezzo, String allestimento, String spazioDisponibile, String localitaCarico, String localitaScarico, String dataRitiro) {
    return DataRow(cells: [
      DataCell(Text(tipoMezzo)),
      DataCell(Text(allestimento)),
      DataCell(Text(spazioDisponibile)),
      DataCell(Text(localitaCarico)),
      DataCell(Text(localitaScarico)),
      DataCell(Text(dataRitiro)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              // Logica per modificare i dettagli del camion
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Logica per eliminare i dettagli del camion
            },
          ),
        ],
      )),
    ]);
  }
}
