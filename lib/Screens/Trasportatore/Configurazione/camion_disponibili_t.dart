import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/add_camion_disponibile_t.dart';
import 'package:flutter_etrucknet_new/Models/camion_model.dart';

class CamionDisponibiliTPage extends StatefulWidget {
  @override
  _CamionDisponibiliTPageState createState() => _CamionDisponibiliTPageState();
}

class _CamionDisponibiliTPageState extends State<CamionDisponibiliTPage> {
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

  List<Camion> filteredCamionList = []; // Lista filtrata per i camion
  final TextEditingController _searchController = TextEditingController(); // Controller per la ricerca
  DateTime? selectedDate; // Data selezionata

  @override
  void initState() {
    super.initState();
    filteredCamionList = camionList; // Inizializza con tutti i camion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camion Disponibili'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(), // Barra di ricerca
            const SizedBox(height: 16),
            _buildCamionTable(), // Tabella dei camion
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Column( // Usa una colonna per le due righe
      children: [
        // Riga per la ricerca dei camion
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Cerca camion',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _filterCamion(value), // Filtra mentre si digita
        ),
        const SizedBox(height: 8), // Spazio tra le righe
        // Riga per la selezione della data
        Row(
          children: [
            Expanded(
              flex: 2, // Permette più spazio per la selezione della data
              child: GestureDetector(
                onTap: () => _selectDate(context), // Apre il selettore di date al tocco
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
                      if (selectedDate != null) // Mostra il pulsante solo se una data è selezionata
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              selectedDate = null; // Resetta la data selezionata
                              _searchController.clear(); // Svuota la barra di ricerca
                              filteredCamionList = camionList; // Mostra di nuovo tutti i camion
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Pulsante per aggiungere un camion
            IconButton(
              icon: const Icon(Icons.add, color: Colors.orange),
              onPressed: () => _openAddCamionDialog(), // Apre il dialog per aggiungere un camion
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
        selectedDate = pickedDate; // Aggiorna la data selezionata
        _searchController.clear(); // Svuota la barra di ricerca
        _filterCamion(selectedDate!.toString()); // Filtra i camion in base alla data selezionata
      });
    }
  }

  void _filterCamion(String query) {
    setState(() {
      filteredCamionList = camionList.where((camion) {
        // Filtra per data se selezionata, altrimenti filtra per testo
        final matchesDate = selectedDate == null || camion.dataRitiro == selectedDate;
        final matchesQuery = camion.localitaCarico.toLowerCase().contains(query.toLowerCase()) ||
                              camion.localitaScarico.toLowerCase().contains(query.toLowerCase()) ||
                              camion.tipoMezzo.toLowerCase().contains(query.toLowerCase());
        return matchesDate && matchesQuery; // Restituisci camion che corrispondono a entrambe le condizioni
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
            onPressed: () => _deleteCamion(camion), // Elimina il camion
          ),
        ],
      )),
    ]);
  }

  Future<void> _openAddCamionDialog({Camion? camion}) async {
    final result = await showDialog<Camion>(
      context: context,
      builder: (BuildContext context) {
        return AddCamionDialog(existingCamion: camion); // Apre il dialog per aggiungere o modificare
      },
    );

    if (result != null) {
      setState(() {
        if (camion == null) {
          camionList.add(result); // Aggiungi un nuovo camion
        } else {
          final index = camionList.indexOf(camion);
          if (index != -1) camionList[index] = result; // Aggiorna un camion esistente
        }
        filteredCamionList = camionList; // Aggiorna la lista filtrata
      });
    }
  }

  void _deleteCamion(Camion camion) {
    setState(() {
      camionList.remove(camion); // Rimuovi il camion dalla lista
      filteredCamionList = camionList; // Aggiorna la lista filtrata
    });
  }
}
