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
              'id' : veicolo['id']?.toString() ?? '',
              'tipo': veicolo['tipoAutomezzoString'] as String,
              'allestimento': veicolo['tipoAllestimentoString'] as String,
              'specifiche': veicolo['specificheString'] as String,
              'descrizione': veicolo['descrizioneCompletaString'] as String,
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
  Future<void> _aggiornaVeicolo(int veicoloId, String tipo, String allestimento, String specifiche) async {
    final token = await getSavedToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token non trovato.')),
      );
      return;
    }

    try {
      final url = Uri.parse('${AppUrl.fleetEndPoint}/flotta/$veicoloId');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'tipoAutomezzoString': tipo,
          'tipoAllestimentoString': allestimento,
          'specificheString': specifiche,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          final index = veicoli.indexWhere((v) => v['id'] == veicoloId.toString());
          if (index != -1) {
            veicoli[index] = {
              'id': veicoloId.toString(),
              'tipo': tipo,
              'allestimento': allestimento,
              'specifiche': specifiche,
            };
            veicoliFiltrati = List.from(veicoli);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veicolo aggiornato con successo.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore durante l\'aggiornamento: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Errore di connessione: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore di connessione: $e')),
      );
    }
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
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: veicoliFiltrati.length,
                itemBuilder: (context, index) {
                  final veicolo = veicoliFiltrati[index];
                  return SizedBox(
                    height: 220,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              veicolo['tipo'] ?? 'Tipo non disponibile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: Icon(
                                Icons.local_shipping,
                                size: 60,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Allestimento: ${veicolo['allestimento'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Specifiche: ${veicolo['specifiche'] ?? 'N/A'}",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ],
                        ),
                      ),
                    )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _aggiungiVeicolo(String tipo, String allestimento, String specifiche) async {
    final token = await getSavedToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token non trovato.')),
      );
      return;
    }

    try {
      final url = Uri.parse('${AppUrl.fleetEndPoint}/flotta');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'tipoAutomezzoString': tipo,
          'tipoAllestimentoString': allestimento,
          'specificheString': specifiche,
        }),
      );

      if (response.statusCode == 201) {
        final nuovoVeicolo = json.decode(response.body);
        setState(() {
          veicoli.add({
            'id': nuovoVeicolo['id'].toString(),
            'tipo': nuovoVeicolo['tipoAutomezzoString'] as String,
            'allestimento': nuovoVeicolo['tipoAllestimentoString'] as String,
            'specifiche': nuovoVeicolo['specificheString'] as String,
          });
          veicoliFiltrati = List.from(veicoli);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veicolo aggiunto con successo.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore durante l\'aggiunta: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Errore di connessione: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore di connessione: $e')),
      );
    }
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
              onPressed: () async {
                if (nuovoTipoMezzo.isNotEmpty &&
                    nuovoAllestimento.isNotEmpty &&
                    nuoveSpecifiche.isNotEmpty) {
                  await _aggiungiVeicolo(nuovoTipoMezzo, nuovoAllestimento, nuoveSpecifiche);
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
                Navigator.of(context).pop();
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
    String tipo = veicolo['tipo'] ?? '';
    String allestimento = veicolo['allestimento'] ?? '';
    String specifiche = veicolo['specifiche'] ?? '';
    int veicoloId = int.tryParse(veicolo['id'] ?? '') ?? -1;

    final tipoController = TextEditingController(text: tipo);
    final allestimentoController = TextEditingController(text: allestimento);
    final specificheController = TextEditingController(text: specifiche);

    if (veicoloId == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: ID veicolo non valido.')),
      );
      return;
    }

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
                controller: tipoController,
                decoration: InputDecoration(labelText: 'Tipo Automezzo'),
              ),
              TextField(
                controller: allestimentoController,
                decoration: InputDecoration(labelText: 'Tipo Allestimento'),
              ),
              TextField(
                controller: specificheController,
                decoration: InputDecoration(labelText: 'Specifiche'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _aggiornaVeicolo(
                  veicoloId,
                  tipoController.text,
                  allestimentoController.text,
                  specificheController.text,
                );
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
                setState(() {
                  veicoli.remove(veicolo);
                  veicoliFiltrati = List.from(veicoli);
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
