import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/transport_model.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/grid_totale_trasporti.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/profile_menu_t_screen.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/side_menu_t.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TotaleTrasportiScreen extends StatefulWidget {
  const TotaleTrasportiScreen({super.key});

  @override
  _TotaleTrasportiScreenState createState() => _TotaleTrasportiScreenState();
}

class _TotaleTrasportiScreenState extends State<TotaleTrasportiScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedStatoTrasporto = 'Tutti';
  String selectedAllestimento = 'Tutti';
  TextEditingController luogoCaricoController = TextEditingController();
  TextEditingController luogoScaricoController = TextEditingController();
  TextEditingController numeroPrezzoController = TextEditingController();

  int trasportatoreId = 0;
  String token = '';
  List<Transport> transports = [];
  bool isLoading = true;

  @override
  void dispose() {
    luogoCaricoController.dispose();
    luogoScaricoController.dispose();
    numeroPrezzoController.dispose();
    super.dispose();
  }

  void _mostraFiltroDate() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
  }

  Future<void> _initializeUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getInt('trasportatore_id') ?? 0;
      final savedToken = prefs.getString('access_token') ?? '';

      setState(() {
        trasportatoreId = savedId;
        token = savedToken;
      });
    } catch (e) {
      log('Errore nel recupero dei dati utente: $e');
    }
  }

  Future<void> _loadTransports() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
          'https://etrucknetapi.azurewebsites.net/v1/Proposte/$trasportatoreId');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
          final List<dynamic> data = decodedResponse['data'];

          setState(() {
            transports = data.map((item) => Transport.fromJson(item)).toList();
          });
        } else {
          log('Errore: il formato della risposta non contiene il campo "data".');
        }
      } else {
        log('Errore nella chiamata API: ${response.statusCode}');
      }
    } catch (e) {
      log('Errore nel caricamento dei trasporti: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeUserData().then((_) => _loadTransports());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Tutti i Trasporti'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileTrasportatorePage()),
              );
            },
          ),
        ],
      ),
      drawer: SideMenuT(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Cerca Trasporto',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedStatoTrasporto,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatoTrasporto = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Stato',
                      border: OutlineInputBorder(),
                    ),
                    items: <String>[
                      'Tutti',
                      'Da Quotare',
                      'In Quotazione',
                      'Quotazione Scaduta'
                    ].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.orange),
                  onPressed: _mostraFiltroDate,
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: selectedAllestimento,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAllestimento = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Tipo Allestimento',
                      border: OutlineInputBorder(),
                    ),
                    items: <String>[
                      'Tutti',
                      'Standard',
                      'Furgone isotermico'
                    ].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: numeroPrezzoController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Prezzo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  width: 30,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          setState(() {
                            int currentValue = int.tryParse(numeroPrezzoController.text) ?? 0;
                            numeroPrezzoController.text = (currentValue + 1).toString();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          setState(() {
                            int currentValue = int.tryParse(numeroPrezzoController.text) ?? 0;
                            numeroPrezzoController.text = (currentValue > 0 ? currentValue - 1 : 0).toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: luogoCaricoController,
                    decoration: InputDecoration(
                      labelText: 'Luogo Carico',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: luogoScaricoController,
                    decoration: InputDecoration(
                      labelText: 'Luogo Scarico',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : TotaleTrasportiGrid(totTrasporti: transports),
            ),
          ],
        ),
      ),
    );
  }
}
