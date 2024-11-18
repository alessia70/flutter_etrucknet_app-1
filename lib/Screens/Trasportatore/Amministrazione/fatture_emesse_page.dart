import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/Amministrazione/grid_fatture_emesse.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/side_menu_t.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FattureEmessePage extends StatefulWidget {
  @override
  _FattureEmessePageState createState() => _FattureEmessePageState();
}

class _FattureEmessePageState extends State<FattureEmessePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? startDate;
  DateTime? endDate;
  int stato = 0;
  int trasportatoreId = 0;

  final List<String> statoEmesseOptions = ['Tutte', 'Scadute', 'Non Scadute', 'Acconto', 'Saldate'];
  String dropdownValue = 'Tutte';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Fatture Emesse'),
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
            _buildSearchAndFilterBox(),
            SizedBox(height: 16),
            Expanded(
              child: GridFattureEmesse(
                trasportatoreId: trasportatoreId,
                startDate: startDate ?? DateTime.now().subtract(Duration(days: 365)),
                endDate: endDate ?? DateTime.now(),
                stato: stato,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBox() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cerca ricevuta...',
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
                items: statoEmesseOptions.map((String value) {
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
                    switch (dropdownValue) {
                      case 'Scadute':
                        stato = 1;
                        break;
                      case 'Non Scadute':
                        stato = 2;
                        break;
                      case 'Acconto':
                        stato = 3;
                        break;
                      case 'Saldate':
                        stato = 4;
                        break;
                      default:
                        stato = 0;
                    }
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
}
