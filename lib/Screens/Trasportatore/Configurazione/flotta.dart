import 'package:flutter/material.dart';

class FlottaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flotta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra di ricerca e pulsanti
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Cerca Automezzo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Aggiungi logica per aggiungere automezzo
                  },
                  icon: Icon(Icons.add),
                  label: Text('Automezzo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Aggiungi logica per filtrare
                  },
                  icon: Icon(Icons.filter_list),
                  label: Text('Filtra'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Card con la tabella
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lista Flotta',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    DataTable(
                      columns: [
                        DataColumn(label: Text('Tipo Automezzo')),
                        DataColumn(label: Text('Tipo Allestimento')),
                        DataColumn(label: Text('Specifiche')),
                        DataColumn(label: Text('Azioni')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('Camion')),
                          DataCell(Text('Standard')),
                          DataCell(Text('Specifiche 1')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // Logica per modificare
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Logica per eliminare
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Furgone')),
                          DataCell(Text('Furgone isotermico')),
                          DataCell(Text('Specifiche 2')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // Logica per modificare
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Logica per eliminare
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]),
                        // Aggiungi altre righe qui
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
