import 'dart:convert';  // Import per convertire la risposta JSON
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/res/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_etrucknet_new/Screens/Trasportatore/side_menu_t.dart';

class FlottaScreen extends StatefulWidget {
  @override
  _FlottaScreenState createState() => _FlottaScreenState();
}

class _FlottaScreenState extends State<FlottaScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedTipoMezzo = 'Tutti';
  String selectedAllestimento = 'Tutti';
  List<Map<String, String>> veicoli = [];
  List<Map<String, String>> veicoliFiltrati = [];  // Inizializzato

  @override
  void initState() {
    super.initState();
    _caricaVeicoli();
  }

  Future<void> _caricaVeicoli() async {
    try {
      // Usa l'endpoint della flotta definito nella classe AppUrl
      final response = await http.get(Uri.parse(AppUrl.fleetEndPoint));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          veicoli = data.map((veicolo) {
            return {
              'tipo': veicolo['tipo'] as String,
              'allestimento': veicolo['allestimento'] as String,
              'specifiche': veicolo['specifiche'] as String,
            };
          }).toList();
          veicoliFiltrati = List.from(veicoli);  // Copia la lista per iniziare
        });
      } else {
        // In caso di errore nel server, mostra un messaggio
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel recupero dei dati')),
        );
      }
    } catch (e) {
      // Gestione errori di rete
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore di connessione: $e')),
      );
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _applicaFiltri() {
    setState(() {
      veicoliFiltrati = veicoli.where((veicolo) {
        bool tipoMatch = selectedTipoMezzo == 'Tutti' || veicolo['tipo'] == selectedTipoMezzo;
        bool allestimentoMatch = selectedAllestimento == 'Tutti' || veicolo['allestimento'] == selectedAllestimento;
        return tipoMatch && allestimentoMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Flotta'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: SideMenuT(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search_outlined),
                      labelText: 'Cerca Automezzo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                IconButton(
                  icon: Icon(Icons.add_box_outlined, color: Colors.orange),
                  onPressed: () {
                    _mostraPopupAggiungi();
                  },
                  tooltip: 'Aggiungi Automezzo',
                ),
                SizedBox(width: 6),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.grey),
                  onPressed: _mostraMenuFiltri,
                  tooltip: 'Filtra',
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Tipo Automezzo')),
                          DataColumn(label: Text('Tipo Allestimento')),
                          DataColumn(label: Text('Specifiche')),
                          DataColumn(label: Text('Azioni')),
                        ],
                        rows: veicoliFiltrati.map((veicolo) {
                          return DataRow(cells: [
                            DataCell(Text(veicolo['tipo']!)),
                            DataCell(Text(veicolo['allestimento']!)),
                            DataCell(Text(veicolo['specifiche']!)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () {
                                       _showEditTruckDialog(context, veicolo); 
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.grey),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context, veicolo);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostraPopupAggiungi() {
    String nuovoTipoMezzo = '';
    String nuovoAllestimento = '';
    String nuoveSpecifiche = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.add, color: Colors.grey),
              Expanded(child: Text('Aggiungi Automezzo')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Tipo Automezzo'),
                onChanged: (value) {
                  nuovoTipoMezzo = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Tipo Allestimento'),
                onChanged: (value) {
                  nuovoAllestimento = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Specifiche'),
                onChanged: (value) {
                  nuoveSpecifiche = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (nuovoTipoMezzo.isNotEmpty && nuovoAllestimento.isNotEmpty && nuoveSpecifiche.isNotEmpty) {
                  setState(() {
                    veicoli.add({
                      'tipo': nuovoTipoMezzo,
                      'allestimento': nuovoAllestimento,
                      'specifiche': nuoveSpecifiche,
                    });
                    veicoliFiltrati = List.from(veicoli);  // Ricalcola la lista filtrata
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tutti i campi devono essere compilati!')),
                  );
                }
              },
              child: Text('Salva'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiude il dialogo
              },
              child: Text('Annulla', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  void _mostraMenuFiltri() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filtri',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tipo Mezzo:'),
                  DropdownButton<String>(
                    value: selectedTipoMezzo,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTipoMezzo = newValue!;
                      });
                    },
                    items: <String>['Tutti', 'Camion', 'Furgone']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tipo Allestimento:'),
                  DropdownButton<String>(
                    value: selectedAllestimento,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAllestimento = newValue!;
                      });
                    },
                    items: <String>[
                      'Tutti',
                      'Standard',
                      'Furgone isotermico'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _applicaFiltri();
                  Navigator.pop(context);
                },
                child: Text('Applica Filtri'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditTruckDialog(BuildContext context, Map<String, String> veicolo) {
    String tipoMezzo = veicolo['tipo']!;
    String allestimento = veicolo['allestimento']!;
    String specifiche = veicolo['specifiche']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Modifica Automezzo'),
              Icon(Icons.edit),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Tipo Automezzo'),
                  controller: TextEditingController(text: tipoMezzo),
                  onChanged: (value) {
                    tipoMezzo = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Tipo Allestimento'),
                  controller: TextEditingController(text: allestimento),
                  onChanged: (value) {
                    allestimento = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Specifiche'),
                  controller: TextEditingController(text: specifiche),
                  onChanged: (value) {
                    specifiche = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  veicolo['tipo'] = tipoMezzo;
                  veicolo['allestimento'] = allestimento;
                  veicolo['specifiche'] = specifiche;
                  veicoliFiltrati = List.from(veicoli);
                });
                Navigator.pop(context);
              },
              child: Text('Salva'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annulla', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Map<String, String> veicolo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conferma Eliminazione'),
          content: Text('Sei sicuro di voler eliminare questo automezzo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annulla', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  veicoli.remove(veicolo); 
                  veicoliFiltrati = List.from(veicoli);
                });
                Navigator.pop(context);
              },
              child: Text('Elimina'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, 
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
