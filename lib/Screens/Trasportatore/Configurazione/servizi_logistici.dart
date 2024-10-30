import 'package:flutter/material.dart';

class ServiziLogisticiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servizi Logistici'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 16),
            _buildServiziTable(),
            SizedBox(height: 16),
            _buildDettagliServiziTable(),
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
              labelText: 'Cerca servizi',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.add, color: Colors.orange),
          onPressed: () {
            // Logica per aggiungere un nuovo servizio
          },
        ),
      ],
    );
  }

  Widget _buildServiziTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tabella dei Servizi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Nome Servizio')),
                  DataColumn(label: Text('Descrizione')),
                  DataColumn(label: Text('Costo')),
                  DataColumn(label: Text('Azioni')),
                ],
                rows: [
                  _buildDataRow('Servizio A', 'Descrizione A', '€100'),
                  _buildDataRow('Servizio B', 'Descrizione B', '€200'),
                  // Aggiungi altre righe come necessario
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDettagliServiziTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dettagli dei Servizi Logistici',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID Servizio')),
                  DataColumn(label: Text('Tipo Servizio')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Dettagli')),
                  DataColumn(label: Text('Azioni')),
                ],
                rows: [
                  _buildDettagliDataRow('1', 'Tipo A', 'Attivo', 'Dettagli A'),
                  _buildDettagliDataRow('2', 'Tipo B', 'Inattivo', 'Dettagli B'),
                  // Aggiungi altre righe come necessario
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String nomeServizio, String descrizione, String costo) {
    return DataRow(cells: [
      DataCell(Text(nomeServizio)),
      DataCell(Text(descrizione)),
      DataCell(Text(costo)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.orange),
            onPressed: () {
              // Logica per modificare il servizio
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.grey),
            onPressed: () {
              // Logica per eliminare il servizio
            },
          ),
        ],
      )),
    ]);
  }

  DataRow _buildDettagliDataRow(String idServizio, String tipoServizio, String status, String dettagli) {
    return DataRow(cells: [
      DataCell(Text(idServizio)),
      DataCell(Text(tipoServizio)),
      DataCell(Text(status)),
      DataCell(Text(dettagli)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.orange),
            onPressed: () {
              // Logica per modificare i dettagli del servizio
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.grey),
            onPressed: () {
              // Logica per eliminare i dettagli del servizio
            },
          ),
        ],
      )),
    ]);
  }
}
