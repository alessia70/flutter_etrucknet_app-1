import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/Registrati/nuovo_committente_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/Registrati/nuovo_trasportatore_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
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
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cerca Anagrafica',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
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
                ),
                SizedBox(width: 130),
                ElevatedButton(
                  onPressed: () {
                    log('Ricerca per: ${_searchController.text}, Categoria: $_selectedCategory');
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
              child: AnagraficheDataGrid(),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.orange,
                width: 3,
              ),
            ),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NuovoCommittenteScreen(),
                  ),
                );
              },
              heroTag: "addCommittente",
              tooltip: 'Aggiungi Committente',
              backgroundColor: Colors.white,
              elevation: 0,
              child: Icon(
                Icons.person_add,
                color: Colors.orange,
              ),
            ),
          ),

          SizedBox(width: 15),

          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NuovoTrasportatoreScreen(),
                ),
              );
            },
            heroTag: "addTrasportatore",
            tooltip: 'Aggiungi Trasportatore',
            child: Icon(Icons.local_shipping, color: Colors.white),
            backgroundColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
