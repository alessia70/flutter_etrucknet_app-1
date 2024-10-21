import 'package:flutter/material.dart';
import 'modifica_camion.dart';

class CamionDisponibiliGrid extends StatefulWidget {
  const CamionDisponibiliGrid({super.key});

  @override

  _CamionDisponibiliGridState createState() => _CamionDisponibiliGridState();
}

class _CamionDisponibiliGridState extends State<CamionDisponibiliGrid> {
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
  ];

  void showEditDialog(BuildContext context, Map<String, String> truck) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditCamionDialog(
          truck: truck,
          onSave: (updatedTruck) {
            setState(() {
              // Trova l'indice del camion da aggiornare
              final index = trucks.indexWhere((t) => t['id'] == updatedTruck['id']);
              if (index != -1) {
                trucks[index] = updatedTruck; // Aggiorna il camion
              }
            });
            Navigator.of(context).pop(); // Chiudi solo il dialogo
          },
        );
      },
    );
  }

  void confirmDeleteTruck(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Conferma Eliminazione"),
          content: const Text("Sei sicuro di voler eliminare questo camion?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annulla", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                deleteTruck(id);
                Navigator.of(context).pop();
              },
              child: const Text("Elimina", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteTruck(String id) {
    setState(() {
      trucks.removeWhere((truck) => truck['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: trucks.length,
      itemBuilder: (context, index) {
        final truck = trucks[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 4,
          margin: const EdgeInsets.all(8),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${truck['id']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
>>>>>>> 66f1e8c60103416a20b43ec7dedd566b35954e36
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Trasportatore:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(truck['transportCompany']!),
                            const SizedBox(height: 10),
                            const Text('Contatto:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(truck['contact']!),
                            const SizedBox(height: 10),
                            const Text('Dati Automezzo:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(truck['vehicleData']!),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Spazio Disponibile:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(truck['availableSpace']!),
                            const SizedBox(height: 10),
                            const Text('Luogo:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(truck['location']!),
                            const SizedBox(height: 10),
                            const Text('Destinazione:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(truck['destination']!),
                            const SizedBox(height: 10),
                            const Text('Data di Carico:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(truck['loadingDate']!),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showEditDialog(context, truck);
                      },
                      child: const Icon(Icons.edit, color: Colors.orange),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        confirmDeleteTruck(context, truck['id']!);
                      },
                      child: const Icon(Icons.close, color: Colors.orange),
                    ),
                  ],
                ),
              ],
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
