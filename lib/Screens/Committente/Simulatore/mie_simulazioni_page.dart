import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Simulatore/confronta_simulazioni_page.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Simulatore/nuova_simulazione_page.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/side_menu_committente.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/data_grid_stime.dart';
import 'package:provider/provider.dart';
import 'package:flutter_etrucknet_new/Services/estimates_provider.dart';

class MieSimulazioniPage extends StatefulWidget {
  const MieSimulazioniPage({super.key});

  @override
  _MieSimulazioniPageState createState() => _MieSimulazioniPageState();
}

class _MieSimulazioniPageState extends State<MieSimulazioniPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedOption = 'Tutte';
  DateTimeRange? _selectedDateRange;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _handleCompare() {
  final estimatesProvider = Provider.of<EstimatesProvider>(context, listen: false);

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (BuildContext context) => ConfrontaSimulazioniDialog(stime: estimatesProvider.estimates),
    ),
  );
}

  void _handleNewEstimate() {
   Navigator.of(context).push(
    MaterialPageRoute(
      builder: (BuildContext context) => NuovaSimulazioneScreen(estimate: {},),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mie Simulazioni'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      drawer: SideMenuCommittente(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cerca simulazioni',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                });
              },
            ),
            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedOption,
                    items: ['Tutte', 'Recenti', 'Vecchie'].map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Filtra per tipo',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedOption = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 20),

                 Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Seleziona periodo',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today, color: Colors.orange,), 
                        ),
                        onTap: () => _selectDateRange(context), 
                        controller: TextEditingController(
                          text: _selectedDateRange == null
                              ? ''
                              : '${_selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${_selectedDateRange!.end.toLocal().toString().split(' ')[0]}',
                        ),
                      ),
                 )
              ],
            ),

            SizedBox(height: 20),

            Expanded(
              child: DataGridStime(), 
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _handleCompare,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,  // Colore del testo
                  ),
                  child: Text('Confronta'),
                ),
                ElevatedButton(
                  onPressed: _handleNewEstimate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,  // Colore di sfondo
                    foregroundColor: Colors.white,  // Colore del testo
                  ),
                  child: Text('Nuova stima'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
