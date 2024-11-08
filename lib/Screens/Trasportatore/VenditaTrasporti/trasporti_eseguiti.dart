import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/grid_trasporti_eseguiti.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/side_menu_t.dart';

class CompletedTransportPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> completedTransports = [
      {
        'id': '1',
        'localitaRitiro': 'Milano',
        'localitaConsegna': 'Roma',
        'dataRitiro': '01/11/2024',
        'dataConsegna': '02/11/2024',
        'tipo': 'Espresso',
      },
      {
        'id': '2',
        'localitaRitiro': 'Torino',
        'localitaConsegna': 'Napoli',
        'dataRitiro': '03/11/2024',
        'dataConsegna': '04/11/2024',
        'tipo': 'Standard',
      },
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Trasporti Eseguiti'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: SideMenuT(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBox(context),
            SizedBox(height: 16),
            Expanded(child: TransportiEseguitiGrid(completedTransports: completedTransports)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cerca trasporto...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orange),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
                suffixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              style: TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.calendar_today_outlined, color: Colors.orange),
            onPressed: () => _mostraFiltroDate(context),
            tooltip: 'Filtra Date',
          ),
        ],
      ),
    );
  }

  void _mostraFiltroDate(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
  }
}
