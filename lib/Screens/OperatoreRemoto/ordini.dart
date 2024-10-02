import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/add_ordine.dart';

class OrdiniScreen extends StatefulWidget {
  const OrdiniScreen({super.key});

  @override
  _OrdiniScreenState createState() => _OrdiniScreenState();
}

class _OrdiniScreenState extends State<OrdiniScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedOption = 'Tutti'; // Valore iniziale per il dropdown
  DateTimeRange? _selectedDateRange; // Valore per il selettore di date

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestione Ordini'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gestione Ordini',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),

                // Barra di ricerca
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Cerca ordini',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Logica per aggiornare i risultati della ricerca
                    });
                  },
                ),
                SizedBox(height: 20),

                // Dropdown e Selettore di Date
                Row(
                  children: [
                    // Dropdown per filtro
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedOption,
                        items: ['Tutti', 'In Corso', 'Completati', 'Annullati']
                            .map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Filtra per stato',
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

                    // TextField per il selettore del periodo
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Seleziona periodo',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today), // Icona del calendario
                        ),
                        onTap: () => _selectDateRange(context), // Mostra il selettore di date al tap
                        controller: TextEditingController(
                          text: _selectedDateRange == null
                              ? ''
                              : '${_selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${_selectedDateRange!.end.toLocal().toString().split(' ')[0]}',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Contenuto aggiuntivo scrollabile qui (es. DataGrid, lista di ordini, ecc.)
                SizedBox(
                  height: 600, // Aggiungi contenuto di esempio per mostrare la scrollabilità
                  child: Center(
                    child: Text(
                      'Contenuto degli ordini qui...',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),


          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddOrdineScreen(),
                  ),
                );
              },
              backgroundColor: Colors.orange, 
              foregroundColor: Colors.white,
              child: Icon(Icons.add_rounded, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
