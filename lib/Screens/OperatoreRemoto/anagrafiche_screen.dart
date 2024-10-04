import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/nuovo_committente_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/nuovo_trasportatore_screen.dart';
import 'anagrafiche_data_grid.dart';

class AnagraficheGridScreen extends StatefulWidget {
  const AnagraficheGridScreen({super.key});

  @override
  _AnagraficheGridScreenState createState() => _AnagraficheGridScreenState();
}

class _AnagraficheGridScreenState extends State<AnagraficheGridScreen> {
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Seleziona categoria...',
    'Cliente',
    'Fornitore',
    'Trasportatore',
    'Dipendente',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anagrafiche'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titolo
            Text(
              'Gestione Anagrafiche',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Barra di Ricerca
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cerca Anagrafica',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Dropdown dei Valori
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: Text('Seleziona categoria'),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
            SizedBox(height: 20),

            // Bottone di Ricerca
            ElevatedButton(
              onPressed: () {
                // Logica di ricerca da implementare
                print('Ricerca per: ${_searchController.text}, Categoria: $_selectedCategory');
              },
              child: Text('Cerca'),
            ),
            SizedBox(height: 20),

            // Griglia delle Anagrafiche
            Expanded(
              child: AnagraficheDataGrid(), // Richiama la griglia in un file separato
            ),
          ],
        ),
      ),

      // Bottoni Flottanti per Aggiungere Committente e Trasportatore
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Bottone Aggiungi Committente
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NuovoCommittenteScreen(), // Pagina "Aggiungi Committente"
                ),
              );
            },
            heroTag: "addCommittente",
            tooltip: 'Aggiungi Committente',
            child: Icon(Icons.person_add, color: Colors.white),
            backgroundColor: Colors.blue,
          ),
          SizedBox(height: 16), // Spazio tra i due bottoni

          // Bottone Aggiungi Trasportatore
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NuovoTrasportatoreScreen(), // Pagina "Aggiungi Trasportatore"
                ),
              );
            },
            heroTag: "addTrasportatore",
            tooltip: 'Aggiungi Trasportatore',
            child: Icon(Icons.local_shipping, color: Colors.white),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
