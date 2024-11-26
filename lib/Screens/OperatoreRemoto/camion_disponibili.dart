import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/camion_disponibili_grid.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/side_menu.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List<Map<String, dynamic>> trucks = [];
  List<Map<String, dynamic>> filteredTrucks = [];

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    print('Token salvato correttamente: $token');
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print('Token recuperato: $token');
    return token;
  }

  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('trasportatore_id');
  }

  Future<void> fetchCamionDisponibili() async {
    final token = await getSavedToken();
    final trasportatoreId = await getSavedUserId();

    if (token == null || trasportatoreId == null) {
      print('Token o TrasportatoreId non trovato.');
      return;
    }

    final url = Uri.parse(
      'https://etrucknetapi.azurewebsites.net/v1/CamionDisponibili'
      '?TrasportatoreId=$trasportatoreId'
      '&StartDate=1900-01-01'
      '&EndDate=2100-01-01',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        print("Dati caricati: ${data.length} camion disponibili.");
        setState(() {
          trucks = List<Map<String, dynamic>>.from(
            data.map((item) => {
              'id': item['id'].toString(),
              'transportCompany': item['transportCompany'] ?? '',
              'contact': item['contact'] ?? '',
              'vehicleData': item['vehicleData'] ?? '',
              'availableSpace': item['availableSpace'] ?? '',
              'location': item['location'] ?? '',
              'destination': item['destination'] ?? '',
              'loadingDate': item['loadingDate'] ?? '',
              'status': item['status'] ?? '',
              'availableFrom': DateTime.parse(item['availableFrom'] ?? '1900-01-01'),
              'availableTo': DateTime.parse(item['availableTo'] ?? '2100-01-01'),
            }),
          );
          filteredTrucks = List.from(trucks);
        });
      } catch (e) {
        print('Errore nel parsing dei dati: $e');
      }
    } else {
      print('Errore nella richiesta: ${response.statusCode}');
    }
  }

  void filterTrucks() {
    final String carrierSearch = _searchCarrierController.text.toLowerCase();
    final String truckSearch = _searchTruckController.text.toLowerCase();
    final String? selectedType = _selectedType;
    final DateTime? selectedFrom = _selectedDateFrom;
    final DateTime? selectedTo = _selectedDateTo;

    setState(() {
      filteredTrucks = trucks.where((truck) {
        final isMatchingCarrier = truck['transportCompany']?.toLowerCase().contains(carrierSearch) ?? false;
        final isMatchingTruck = truck['vehicleData']?.toLowerCase().contains(truckSearch) ?? false;
        final isMatchingType = selectedType == null || truck['status'] == selectedType;
        final isMatchingDateRange = (selectedFrom == null || truck['availableFrom'].isAfter(selectedFrom)) &&
                                    (selectedTo == null || truck['availableTo'].isBefore(selectedTo));

        return isMatchingCarrier && isMatchingTruck && isMatchingType && isMatchingDateRange;
      }).toList();
    });

    print("Camion filtrati: ${filteredTrucks.length}");
  }

  @override
  void initState() {
    super.initState();
    fetchCamionDisponibili();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camion Disponibili'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const ProfilePage())
              );
            },
          ),
        ],
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
                        icon: Icon(Icons.calendar_today, color: Colors.orange),
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
                    filterTrucks();
                  },
                  child: Text(
                    'Cerca',
                    style: TextStyle(color: Colors.orange),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: CamionDisponibiliGrid(camion: filteredTrucks),
            ),
          ],
        ),
      ),
    );
  }
}
