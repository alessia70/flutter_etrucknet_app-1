import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/rdtEseguiti_model.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Trasporti/preventivi_richiesti_page.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/side_menu_committente.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';

class CommittenteDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bacheca Committente'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      drawer: SideMenuCommittente(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 16,
                children: [
                  _buildSquareCard(context, 'Richiedi targa e autista', Icons.request_quote_outlined, () {
                    _showTargaDialog(context, RdtEseguiti as RdtEseguiti);
                  }),
                  _buildSquareCard(context, 'Trasporti Non Assegnati', Icons.assignment_ind, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PreventiviRichiestiPage()),
                    );
                  }),
                  _buildSquareCard(context, 'Stima il costo del tuo trasporto', Icons.search, () {
                    Navigator.pushNamed(context, '/trova_carichi');
                  }),
                  _buildSquareCard(context, 'Trend Costo trasporto', Icons.trending_up, () {
                    Navigator.pushNamed(context, '/trend_costo_carburante');
                  }),
                ],
              ),
              SizedBox(height: 20),
              _buildTransportRequestCard(context),
              SizedBox(height: 20),
              _buildNotificationCard(context),
            ],
          ),
        ),
      ),
    );
  }

  void _showTargaDialog(BuildContext context, RdtEseguiti rdtEseguiti) {
    final ordineId = rdtEseguiti.id;
    final dataCarico = rdtEseguiti.dataCarico;
    final luogoCarico = rdtEseguiti.luogoCarico;
    final luogoScarico = rdtEseguiti.luogoScarico; 
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Richiedi Targa',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  border: TableBorder.all(color: Colors.grey),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Campo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Valore',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    _buildTableRow('ID Ordine', ordineId.toString()),
                    _buildTableRow('Data Carico', dataCarico as String),
                    _buildTableRow('Carico', luogoCarico!),
                    _buildTableRow('Scarico', luogoScarico!),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Chiudi'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Conferma'),
            ),
          ],
        );
      },
    );
  }

  TableRow _buildTableRow(String campo, String valore) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            campo,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(valore),
        ),
      ],
    );
  }

  Widget _buildSquareCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Card(
        elevation: 4,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.orange),
                SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
            SizedBox(
              width: double.infinity,
              child: _buildScrollableDataTable(
                columns: const [
                  DataColumn(label: Text('IdOrdine')),
                  DataColumn(label: Text('Data Carico')),
                  DataColumn(label: Text('Luogo Carico')),
                  DataColumn(label: Text('Luogo Scarico')),
                  DataColumn(label: Text('')),
                ],
                rows: List<DataRow>.generate(
                  5,
                  (index) => DataRow(cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(Text('01/01/2024')),
                    DataCell(Text('Luogo ${index + 1}')),
                    DataCell(Text('Luogo ${index + 2}')),
                    DataCell(
                      TextButton(
                        onPressed: () {
                          // Logica per quotare
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
            SizedBox(
              width: double.infinity,
              child: _buildScrollableDataTable(
                columns: const [
                  DataColumn(label: Text('Data')),
                  DataColumn(label: Text('Messaggio')),
                ],
                rows: List<DataRow>.generate(
                  5,
                  (index) => DataRow(cells: [
                    DataCell(Text('01/01/2024')),
                    DataCell(Text('Messaggio di notifica ${index + 1}')),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableDataTable({required List<DataColumn> columns, required List<DataRow> rows}) {
    ScrollController _scrollController = ScrollController();

    return Container(
      width: double.infinity,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: DataTable(
            columns: columns,
            rows: rows,
          ),
        ),
      ),
    );
  }
}
