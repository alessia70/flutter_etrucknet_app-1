import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/profile_menu_t_screen.dart';
import 'package:flutter_etrucknet_new/res/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_etrucknet_new/Screens/Trasportatore/side_menu_t.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlottaScreen extends StatefulWidget {
  @override
  _FlottaScreenState createState() => _FlottaScreenState();
}

class _FlottaScreenState extends State<FlottaScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedTipoMezzo = 'Tutti';
  String selectedAllestimento = 'Tutti';
  List<Map<String, String>> veicoli = [];
  List<Map<String, String>> veicoliFiltrati = [];
  int trasportatoreId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('trasportatore_id');
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _loadUserData() async {
    final trasportatoreId = await getSavedUserId();
    final token = await getSavedToken();
    if (trasportatoreId == null || token == null) {
      print('Errore: userId o token non trovato');
      return;
    }
    setState(() {
      this.trasportatoreId = trasportatoreId;
    });
    _caricaVeicoli(token, trasportatoreId);
  }

  Future<void> _caricaVeicoli(String token, int trasportatoreId) async {
    try {
      final url = Uri.parse('${AppUrl.fleetEndPoint}/flotta/$trasportatoreId');

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          veicoli = data.map((veicolo) {
            return {
              'tipo': veicolo['tipoAutomezzoString'] as String ?? '',
              'allestimento': veicolo['tipoAllestimentoString'] as String ?? '',
              'specifiche': veicolo['specificheString'] as String ?? '',
              'descrizione': veicolo['descrizioneCompletaString'] as String ?? '',
            };
          }).toList();
          veicoliFiltrati = List.from(veicoli); 
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel recupero dei dati: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Errore di connessione: $e');
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
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const ProfileTrasportatorePage())
              );
            },
          ),
        ],
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
                  onPressed: _mostraPopupAggiungi,
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
                                    onPressed: () => _showEditTruckDialog(context, veicolo),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.grey),
                                    onPressed: () => _showDeleteConfirmationDialog(context, veicolo),
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
              DropdownButton<String>(
                value: selectedTipoMezzo,
                items: ['Tutti', 'Tipo 1', 'Tipo 2', 'Tipo 3'].map((tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTipoMezzo = value!;
                  });
                  _applicaFiltri();
                },
              ),
              SizedBox(height: 12),
              DropdownButton<String>(
                value: selectedAllestimento,
                items: ['Tutti', 'Allestimento 1', 'Allestimento 2'].map((tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAllestimento = value!;
                  });
                  _applicaFiltri();
                },
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applicaFiltri();
                },
                child: Text('Applica Filtri'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditTruckDialog(BuildContext context, Map<String, String> veicolo) {
    String tipo = veicolo['tipo']!;
    String allestimento = veicolo['allestimento']!;
    String specifiche = veicolo['specifiche']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.edit, color: Colors.grey),
              Expanded(child: Text('Modifica Automezzo')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: tipo),
                decoration: InputDecoration(labelText: 'Tipo Automezzo'),
                onChanged: (value) {
                  tipo = value;
                },
              ),
              TextField(
                controller: TextEditingController(text: allestimento),
                decoration: InputDecoration(labelText: 'Tipo Allestimento'),
                onChanged: (value) {
                  allestimento = value;
                },
              ),
              TextField(
                controller: TextEditingController(text: specifiche),
                decoration: InputDecoration(labelText: 'Specifiche'),
                onChanged: (value) {
                  specifiche = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Modifica il veicolo
                setState(() {
                  veicolo['tipo'] = tipo;
                  veicolo['allestimento'] = allestimento;
                  veicolo['specifiche'] = specifiche;
                });
                Navigator.of(context).pop();
              },
              child: Text('Salva'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
          title: Text('Conferma'),
          content: Text('Sei sicuro di voler eliminare questo veicolo?'),
          actions: [
            TextButton(
              onPressed: () {
                // Elimina il veicolo dalla lista
                setState(() {
                  veicoli.remove(veicolo);
                  veicoliFiltrati = List.from(veicoli); // Ricalcola i veicoli filtrati
                });
                Navigator.of(context).pop();
              },
              child: Text('Sì'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annulla'),
            ),
          ],
        );
      },
    );
  }
}
