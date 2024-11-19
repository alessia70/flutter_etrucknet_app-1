import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_etrucknet_new/Models/camion_model.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/add_camion_disponibile_t.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/side_menu_t.dart';

class CamionDisponibiliTPage extends StatefulWidget {
  @override
  _CamionDisponibiliTPageState createState() => _CamionDisponibiliTPageState();
}

class _CamionDisponibiliTPageState extends State<CamionDisponibiliTPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  DateTime? selectedDate;
  late Future<List<Camion>> futureCamion;

  @override
  void initState() {
    super.initState();
    futureCamion = fetchCamionDisponibili();
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('trasportatore_id');
  }

  Future<List<Camion>> fetchCamionDisponibili() async {
    final token = await getSavedToken();
    final trasportatoreId = await getSavedUserId();

    final defaultStartDate = DateTime(1900, 1, 1);
    final futureEndDate = DateTime(2100, 12, 31);

    final url = Uri.parse(
      'https://etrucknetapi.azurewebsites.net/v1/CamionDisponibili?StartDate=${defaultStartDate.toIso8601String()}&EndDate=${futureEndDate.toIso8601String()}&TrasportatoreId=$trasportatoreId',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Camion> camionList = data.map((json) => Camion.fromJson(json)).toList();

      if (camionList.isEmpty) {
        print('Nessun camion disponibile.');
        return [];
      } else {
        DateTime endDate = camionList
            .map((camion) => camion.dataRitiro)
            .reduce((a, b) => a.isAfter(b) ? a : b);

        final updatedUrl = Uri.parse(
          'https://etrucknetapi.azurewebsites.net/v1/CamionDisponibili?StartDate=${defaultStartDate.toIso8601String()}&EndDate=${endDate.toIso8601String()}&TrasportatoreId=$trasportatoreId',
        );

        final updatedResponse = await http.get(
          updatedUrl,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        if (updatedResponse.statusCode == 200) {
          List<dynamic> updatedData = json.decode(updatedResponse.body);
          return updatedData.map((json) => Camion.fromJson(json)).toList();
        } else {
          print('Error response: ${updatedResponse.statusCode}');
          print('Error body: ${updatedResponse.body}');
          throw Exception('Errore durante la richiesta con le date aggiornate: ${updatedResponse.statusCode}');
        }
      }
    } else {
      print('Error response: ${response.statusCode}');
      print('Error body: ${response.body}');
      throw Exception('Errore nel recupero dei camion: ${response.statusCode}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Camion Disponibili'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(child: _buildCamionList()),
          ],
        ),
      ),
      drawer: SideMenuT(),
    );
  }

  Widget _buildSearchBar() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Cerca camion',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? 'Data: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                            : 'Seleziona Data',
                        style: TextStyle(
                          color: selectedDate != null ? Colors.black : Colors.grey,
                        ),
                      ),
                      if (selectedDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              selectedDate = null;
                              _searchController.clear();
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.orange),
              onPressed: () => _openAddCamionDialog(),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _searchController.clear();
      });
    }
  }

  Widget _buildCamionList() {
    return FutureBuilder<List<Camion>>(
      future: futureCamion,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Errore: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Nessun camion disponibile.'));
        } else {
          final camionList = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Tipo Mezzo')),
                DataColumn(label: Text('Spazio Disponibile (cm)')),
                DataColumn(label: Text('Luogo di Carico')),
                DataColumn(label: Text('Data di Ritiro')),
                DataColumn(label: Text('Luogo di Scarico')),
                DataColumn(label: Text('Azioni')),
              ],
              rows: camionList.map((camion) => _buildDataRow(camion)).toList(),
            ),
          );
        }
      },
    );
  }

  DataRow _buildDataRow(Camion camion) {
    return DataRow(cells: [
      DataCell(Text(camion.tipoMezzo)),
      DataCell(Text(camion.spazioDisponibile.toString())),
      DataCell(Text(camion.localitaCarico ?? 'Non specificato')),
      DataCell(Text('${camion.dataRitiro.day}/${camion.dataRitiro.month}/${camion.dataRitiro.year}')),
      DataCell(Text(camion.localitaScarico ?? 'Non specificato')),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.orange),
            onPressed: () => _openAddCamionDialog(camion: camion),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.grey),
            onPressed: () => _confirmDelete(camion.id),
          ),
        ],
      )),
    ]);
  }

  Future<void> _confirmDelete(int? camionId) async {
    if (camionId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Conferma eliminazione'),
        content: Text('Vuoi eliminare questo camion?'),
        actions: [
          TextButton(
            child: Text('Annulla'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Elimina'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await deleteCamion(camionId);
    }
  }

  Future<void> _openAddCamionDialog({Camion? camion}) async {
    final result = await showDialog<Camion>(
      context: context,
      builder: (BuildContext context) {
        return AddCamionDialog(existingCamion: camion);
      },
    );

    if (result != null) {
      setState(() {
        futureCamion = fetchCamionDisponibili();
      });
    }
  }

  Future<void> deleteCamion(int camionId) async {
    final token = await getSavedToken();

    if (token == null) {
      throw Exception('Token non trovato.');
    }

    final url = Uri.parse(
      'https://etrucknetapi.azurewebsites.net/v1/CamionDisponibili/$camionId',
    );

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      setState(() {
        futureCamion = fetchCamionDisponibili();
      });
    } else {
      throw Exception('Errore durante l\'eliminazione: ${response.statusCode}');
    }
  }
}

