import 'package:flutter/material.dart';

class CamionDisponibiliGrid extends StatelessWidget {
  const CamionDisponibiliGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Esempio di dati dei camion
    final List<Map<String, String>> trucks = [
      {
        'id': '1',
        'transportCompany': 'Trasporti A',
        'contact': '123-456-7890',
        'vehicleData': 'Camion A - 10 ton',
        'availableSpace': '5 ton',
        'location': 'Milano',
        'destination': 'Firenze',
        'loadingDate': '2024-10-15',
      },
      {
        'id': '2',
        'transportCompany': 'Trasporti B',
        'contact': '098-765-4321',
        'vehicleData': 'Camion B - 15 ton',
        'availableSpace': '10 ton',
        'location': 'Roma',
        'destination': 'Napoli',
        'loadingDate': '2024-10-16',
      },
      {
        'id': '3',
        'transportCompany': 'Trasporti C',
        'contact': '111-222-3333',
        'vehicleData': 'Camion C - 8 ton',
        'availableSpace': '3 ton',
        'location': 'Torino',
        'destination': 'Bologna',
        'loadingDate': '2024-10-17',
      },
      // Aggiungi più camion qui
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Numero di colonne nella griglia
        childAspectRatio: 1.8, // Proporzione di ogni elemento della griglia
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: trucks.length,
      itemBuilder: (context, index) {
        return Card(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titolo con ID camion
                  Text(
                    'ID: ${trucks[index]['id']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(height: 10),

                  // Due colonne per i campi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Colonna di sinistra
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Trasportatore:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(trucks[index]['transportCompany']!),
                            const SizedBox(height: 10),
                            Text('Contatto:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(trucks[index]['contact']!),
                            const SizedBox(height: 10),
                            Text('Dati Automezzo:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(trucks[index]['vehicleData']!),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Colonna di destra
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Spazio Disponibile:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(trucks[index]['availableSpace']!),
                            const SizedBox(height: 10),
                            Text('Luogo:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(trucks[index]['location']!),
                            const SizedBox(height: 10),
                            Text('Destinazione:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(trucks[index]['destination']!),
                            const SizedBox(height: 10),
                            Text('Data di Carico:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(trucks[index]['loadingDate']!),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20), // Spazio tra i campi e i bottoni
                  // Bottoni
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Logica per modificare il camion
                        },
                        child: const Icon(Icons.edit, color: Colors.orange), // Icona arancione
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Logica per chiudere il trasporto
                        },
                        child: const Icon(Icons.close, color: Colors.orange), // Icona arancione
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 4,
          margin: const EdgeInsets.all(8),
        );
      },
    );
  }
}
