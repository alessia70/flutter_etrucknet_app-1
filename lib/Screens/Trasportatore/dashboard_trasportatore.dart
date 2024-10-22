import 'package:flutter/material.dart';

class TrasportatoreDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bacheca Trasportatore'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(context, 'Aggiungi', Icons.add, '/aggiungi'),
            SizedBox(height: 16),
            _buildCard(context, 'Camion Disponibili', Icons.local_shipping, '/camion_disponibili'),
            SizedBox(height: 16),
            _buildCard(context, 'Trova i Tuoi Carichi', Icons.search, '/trova_carichi'),
            SizedBox(height: 16),
            _buildCard(context, 'Trend Costo Carburante', Icons.trending_up, '/trend_costo_carburante'),
            SizedBox(height: 20), // Spaziatura tra le card
            _buildTransportRequestCard(context),
            SizedBox(height: 20), // Spaziatura tra le card
            _buildNotificationCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, String route) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route); // Naviga verso la rotta specificata
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.orange),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, route);
                },
                child: Text('Vai'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransportRequestCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Richieste di Trasporto',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Tabella
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('IdOrdine')),
                  DataColumn(label: Text('Data Carico')),
                  DataColumn(label: Text('Luogo Carico')),
                  DataColumn(label: Text('Luogo Scarico')),
                  DataColumn(label: Text('')),
                ],
                rows: List<DataRow>.generate(
                  5, // Numero di righe da visualizzare
                  (index) => DataRow(cells: [
                    DataCell(Text('${index + 1}')), // IdOrdine
                    DataCell(Text('01/01/2024')), // Data Carico
                    DataCell(Text('Luogo ${index + 1}')), // Luogo Carico
                    DataCell(Text('Luogo ${index + 2}')), // Luogo Scarico
                    DataCell(
                      TextButton(
                        onPressed: () {
                          // Aggiungi la logica per quotare
                        },
                        child: Text(
                          'Da Quotare',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifiche',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Tabella delle notifiche
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Data')),
                  DataColumn(label: Text('Messaggio')),
                ],
                rows: List<DataRow>.generate(
                  5, // Numero di righe da visualizzare
                  (index) => DataRow(cells: [
                    DataCell(Text('01/01/2024')), // Data
                    DataCell(Text('Messaggio di notifica ${index + 1}')), // Messaggio
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
