import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Amminiztrazione/fatture_ricevute_committente_grid.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/profile_menu_committente.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/side_menu_committente.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FattureRicevuteCommittentePage extends StatefulWidget {
  @override
  _FattureRicevuteCommittentePageState createState() => _FattureRicevuteCommittentePageState();
}

class _FattureRicevuteCommittentePageState extends State<FattureRicevuteCommittentePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String dropdownValue = 'Tutte';
  DateTime? startDate;
  DateTime? endDate;
  int stato = 1;
  int trasportatoreId = 0;
  final List<String> statoRicevuteOptions = ['Tutte', 'Scadute', 'Non Scadute', 'Acconto', 'Saldate'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    startDate = DateTime.now().subtract(Duration(days: 365));
    endDate = DateTime.now();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      trasportatoreId = prefs.getInt('trasportatoreId') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Fatture Ricevute'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileCommittentePage())
              );
            },
          )
        ],
      ),
      drawer: SideMenuCommittente(),
      body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchAndFilterBox(context),
                  SizedBox(height: 16),
                  Expanded(
                    child: GridFattureRicevuteCommittente(
                      trasportatoreId: trasportatoreId,
                      startDate: startDate!,
                      endDate: endDate!,
                      stato: stato,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSearchAndFilterBox(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cerca fattura...',
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
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: dropdownValue,
                items: statoRicevuteOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
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
      ],
    );
  }

  void _mostraFiltroDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialDateRange: DateTimeRange(start: startDate!, end: endDate!),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }
}
