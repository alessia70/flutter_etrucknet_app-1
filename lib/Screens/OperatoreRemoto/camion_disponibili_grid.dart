import 'package:flutter/material.dart';

class CamionDisponibiliGrid extends StatelessWidget {
  const CamionDisponibiliGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Esempio di dati dei camion
    final List<Map<String, String>> trucks = [
      {'name': 'Camion A', 'capacity': '10 ton', 'location': 'Milano'},
      {'name': 'Camion B', 'capacity': '15 ton', 'location': 'Roma'},
      {'name': 'Camion C', 'capacity': '8 ton', 'location': 'Torino'},
      // Aggiungi più camion qui
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Numero di colonne nella griglia
        childAspectRatio: 1.5, // Proporzione di ogni elemento della griglia
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: trucks.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  trucks[index]['name']!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Capacità: ${trucks[index]['capacity']}'),
                SizedBox(height: 10),
                Text('Posizione: ${trucks[index]['location']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
