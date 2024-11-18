import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/add_camion_disponibile_t.dart';
import 'package:flutter_etrucknet_new/Models/camion_model.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/side_menu_t.dart';

class CamionDisponibiliTPage extends StatefulWidget {
  @override
  _CamionDisponibiliTPageState createState() => _CamionDisponibiliTPageState();
}

class _CamionDisponibiliTPageState extends State<CamionDisponibiliTPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Camion> camionList = [
    Camion(
      tipoMezzo: 'Camion A',
      spazioDisponibile: 500,
      localitaCarico: 'Roma',
      dataRitiro: DateTime(2024, 11, 1),
      localitaScarico: 'Milano',
    ),
    Camion(
      tipoMezzo: 'Camion B',
      spazioDisponibile: 600,
      localitaCarico: 'Torino',
      dataRitiro: DateTime(2024, 11, 2),
      localitaScarico: 'Firenze',
    ),
  ];

  List<Camion> filteredCamionList = [];
  final TextEditingController _searchController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    filteredCamionList = camionList;
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
            _buildCamionTable(),
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
          onChanged: (value) => _filterCamion(value),
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
                              filteredCamionList = camionList;
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
        _filterCamion(selectedDate!.toString());
      });
    }
  }

  void _filterCamion(String query) {
    setState(() {
      filteredCamionList = camionList.where((camion) {
        final matchesDate = selectedDate == null || camion.dataRitiro == selectedDate;
        final matchesQuery = camion.localitaCarico.toLowerCase().contains(query.toLowerCase()) ||
                              camion.localitaScarico.toLowerCase().contains(query.toLowerCase()) ||
                              camion.tipoMezzo.toLowerCase().contains(query.toLowerCase());
        return matchesDate && matchesQuery;
      }).toList();
    });
  }

  Widget _buildCamionTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tabella dei Camion',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SingleChildScrollView(
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
                rows: filteredCamionList.map((camion) {
                  return _buildDataRow(camion);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(Camion camion) {
    return DataRow(cells: [
      DataCell(Text(camion.tipoMezzo)),
      DataCell(Text(camion.spazioDisponibile.toString())),
      DataCell(Text(camion.localitaCarico)),
      DataCell(Text('${camion.dataRitiro.day}/${camion.dataRitiro.month}/${camion.dataRitiro.year}')),
      DataCell(Text(camion.localitaScarico)),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.orange),
            onPressed: () => _openAddCamionDialog(camion: camion), // Modifica il camion
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.grey),
            onPressed: () => _deleteCamion(camion),
          ),
        ],
      )),
    ]);
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
        if (camion == null) {
          camionList.add(result);
        } else {
          final index = camionList.indexOf(camion);
          if (index != -1) camionList[index] = result;
        }
        filteredCamionList = camionList;
      });
    }
  }

  void _deleteCamion(Camion camion) {
    setState(() {
      camionList.remove(camion);
      filteredCamionList = camionList;
    });
  }
}
