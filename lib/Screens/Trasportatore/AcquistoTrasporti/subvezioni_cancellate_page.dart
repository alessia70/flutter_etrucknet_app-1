import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/AcquistoTrasporti/grid_subvezioni_cancellate.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/AcquistoTrasporti/nuova_richieste_subvezioni_page.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/AcquistoTrasporti/richieste_subvezioni_page.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/side_menu_t.dart';

class SubvezioniCancellatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    List<Map<String, String>> subvezioniCancellate = [
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
        title: Text('Sub-vezioni Cancellate'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          }, 
          icon: Icon(Icons.menu)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBox(context),
            SizedBox(height: 8),
            _buildActionButtons(context),
            SizedBox(height: 16),
            Expanded(
              child: GridSubvezioniCancellate(
                completedTransports: subvezioniCancellate,
              ),
            ),
          ],
        ),
      ),
      drawer: SideMenuT(),
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            _richiediOfferte(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
          ),
          child: Text("Richiedi Offerte"),
        ),
        ElevatedButton(
          onPressed: () {
            _richiesteInCorso(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
          ),
          child: Text("Richieste in corso"),
        ),
      ],
    );
  }

  void _mostraFiltroDate(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
  }

  void _richiediOfferte(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuovaRichiestaSubvezioneScreen(),
      ),
    );
  }

  void _richiesteInCorso(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RichiesteSubvezioniPage(),
      ),
    );
  }
}
