import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_screen.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/Configurazione/camion_disponibili_t.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/add_camion_disponibile_t.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/side_menu_t.dart';

class TrasportatoreDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bacheca Trasportatore'),
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
      drawer: SideMenuT(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4, //2
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildSquareCard(context, 'Aggiungi camion', Icons.add, () {
                    _showAddTruckDialog(context);
                  }),
                  _buildSquareCard(context, 'Camion Disponibili', Icons.local_shipping, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CamionDisponibiliTPage()),
                    );
                  }),
                  _buildSquareCard(context, 'Trova i Tuoi Carichi', Icons.search, () {
                    Navigator.pushNamed(context, '/trova_carichi');
                  }),
                  _buildSquareCard(context, 'Trend Costo Carburante', Icons.trending_up, () {
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

  void _showAddTruckDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCamionDialog();
      },
    );
  }

  Widget _buildSquareCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      width: 200,
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 4,
          child: Stack(
            children: [
              Center(
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
              Positioned(
                top: 6,
                right: 6,
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(28, 28),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Colors.orange,
                  ),
                ),
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
            Container(
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
            Container(
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
