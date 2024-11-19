import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'modifica_camion.dart';

class CamionDisponibiliGrid extends StatefulWidget {
  const CamionDisponibiliGrid({super.key});

  @override
  _CamionDisponibiliGridState createState() => _CamionDisponibiliGridState();
}

class _CamionDisponibiliGridState extends State<CamionDisponibiliGrid> {
  List<Map<String, String>> trucks = [];

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('trasportatore_id');
  }
  Future<void> fetchCamionDisponibili() async {
    final token = await getSavedToken();
    final trasportatoreId = await getSavedUserId();

    if (token == null || trasportatoreId == null) {
      print('Token or TrasportatoreId not found.');
      return;
    }

    final url = Uri.parse(
      'https://etrucknetapi.azurewebsites.net/v1/CamionDisponibili?TrasportatoreId=$trasportatoreId',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      setState(() {
        trucks = List<Map<String, String>>.from(
          data.map((item) => {
            'id': item['id'].toString(),
            'transportCompany': item['transportCompany'] ?? '',
            'contact': item['contact'] ?? '',
            'vehicleData': item['vehicleData'] ?? '',
            'availableSpace': item['availableSpace'] ?? '',
            'location': item['location'] ?? '',
            'destination': item['destination'] ?? '',
            'loadingDate': item['loadingDate'] ?? '',
          }),
        );
      });
    } else {
      print('Error fetching camion data: ${response.statusCode}');
      throw Exception('Failed to load camion data');
    }
  }
  void showEditDialog(BuildContext context, Map<String, String> truck) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditCamionDialog(
          truck: truck,
          onSave: (updatedTruck) {
            setState(() {
              final index = trucks.indexWhere((t) => t['id'] == updatedTruck['id']);
              if (index != -1) {
                trucks[index] = updatedTruck;
              }
            });
            Navigator.of(context).pop();
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
  void initState() {
    super.initState();
    fetchCamionDisponibili();
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
        );
      },
    );
  }
}
