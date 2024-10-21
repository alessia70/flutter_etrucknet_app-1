import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/camion_disponibili_grid.dart';
import 'package:flutter_etrucknet_new/Widgets/side_menu.dart';
import 'package:intl/intl.dart';

class AvailableTrucksScreen extends StatefulWidget {
  const AvailableTrucksScreen({super.key});

  @override
  _AvailableTrucksScreenState createState() => _AvailableTrucksScreenState();
}

class _AvailableTrucksScreenState extends State<AvailableTrucksScreen> {
  String? _selectedType;
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  final TextEditingController _searchCarrierController = TextEditingController();
  final TextEditingController _searchTruckController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camion Disponibili'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchCarrierController,
              decoration: InputDecoration(
                labelText: 'Cerca Carrier',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchTruckController,
                    decoration: InputDecoration(
                      labelText: 'Cerca Camion',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                DropdownButton<String>(
                  hint: Text('Tipo'),
                  value: _selectedType,
                  items: <String>['In corso', 'Annullati', 'Liberi']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Data Inizio',
                      border: OutlineInputBorder(),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.calendar_today, color: Colors.orange), // Icona del calendario
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDateFrom ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (picked != null) {
                            setState(() {
                              _selectedDateFrom = picked;
                            });
                          }
                        },
                      ),
                    ),
                    controller: TextEditingController(text: _selectedDateFrom != null 
                      ? DateFormat('dd/MM/yyyy').format(_selectedDateFrom!)
                      : ''),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Data Fine',
                      border: OutlineInputBorder(),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.calendar_month, color: Colors.orange),
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDateTo ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (picked != null) {
                            setState(() {
                              _selectedDateTo = picked;
                            });
                          }
                        },
                      ),
                    ),
                    controller: TextEditingController(text: _selectedDateTo != null 
                      ? DateFormat('dd/MM/yyyy').format(_selectedDateTo!)
                      : ''),
                  ),
                ),
                SizedBox(width: 25),

                ElevatedButton(
                  onPressed: () {
                    print('Ricerca');
                  },
                  child: Text(
                    'Cerca',
                    style: TextStyle(color: Colors.orange),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange,
                    side: BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: CamionDisponibiliGrid(),
            ),
          ],
        ),
      ),
    );
  }
}
