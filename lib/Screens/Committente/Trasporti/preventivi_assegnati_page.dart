import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/Trasporti/data_grid_preventivi_assegnati.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/profile_menu_committente.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/side_menu_committente.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/AcquistoTrasporti/nuova_richieste_subvezioni_page.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/AcquistoTrasporti/subvezioni_cancellate_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PreventiviAssegnatiPage extends StatefulWidget {
  @override
  _PreventiviAssegnatiPageState createState() => _PreventiviAssegnatiPageState();
}

class _PreventiviAssegnatiPageState extends State<PreventiviAssegnatiPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, String>> preventiviAssegnati = [];

  @override
  void initState() {
    super.initState();
    _fetchProposals();
  }

  Future<Map<String, dynamic>> _getTokenAndTransporterId() async {
    final token = await getSavedToken();
    final transporterId = await getSavedUserId();

    if (token == null || transporterId == null) {
      setState(() {
        _errorMessage = 'Token o ID trasportatore non trovato. Verifica i dati.';
        _isLoading = false;
      });
      return {};
    }
    return {'token': token, 'transporterId': transporterId};
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('trasportatore_id');
  }
  Future<void> _fetchProposals() async {
    final tokenAndId = await _getTokenAndTransporterId();
    final token = tokenAndId['token'];
    final transporterId = tokenAndId['transporterId'];

    if (token == null || transporterId == null) {
      setState(() {
        _errorMessage = 'Token o ID trasportatore non trovato. Verifica i dati.';
        _isLoading = false;
      });
      return;
    }

    DateTimeRange dateRange = DateTimeRange(
      start: DateTime(2000, 01, 01),
      end: DateTime(2100, 01, 01),
    );

    String url = 'https://etrucknetapi.azurewebsites.net/v1/Proposte/8324'
        '?TrasportatoreId=$transporterId'
        '&inviato=false'
        '&latitudineCarico='
        '&longitudineCarico='
        '&latitudineScarico='
        '&longitudineScarico='
        '&Tolleranza='
        '&AllestimentoSelezionato=Tutti'
        '&dataInizio=${dateRange.start.toIso8601String()}'
        '&dataFine=${dateRange.end.toIso8601String()}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          preventiviAssegnati = _parseProposals(response.body);
          _isLoading = false;
          if (preventiviAssegnati.isEmpty) {
            _errorMessage = 'Nessun preventivo trovato.';
          }
        });
      } else {
        setState(() {
          _errorMessage = 'Errore nella richiesta: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Errore di connessione: $e";
        _isLoading = false;
      });
    }
  }
  List<Map<String, String>> _parseProposals(String responseBody) {
    try {
      final parsed = json.decode(responseBody);
      if (parsed is Map<String, dynamic> && parsed['data'] is List) {
        return (parsed['data'] as List).map<Map<String, String>>((json) {
          return {
            'id': json['ordineId'].toString(), 
            'localitaRitiro': json['carico'] ?? 'Non disponibile',
            'localitaConsegna': json['scarico'] ?? 'Non disponibile',
            'dataRitiro': json['dataInizio'] != null
                ? DateTime.parse(json['dataInizio']).toLocal().toString()
                : 'Non disponibile',
            'dataConsegna': json['dataFine'] != null
                ? DateTime.parse(json['dataFine']).toLocal().toString()
                : 'Non disponibile',
            'tipo': json['operatore'] ?? 'Non disponibile',
          };
        }).toList();
      } else {
        log('Errore: risposta non in formato lista o chiave "data" mancante');
        return [];
      }
    } catch (e) {
      log('Errore nel parsing dei dati: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Preventivi Assegnati'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const ProfileCommittentePage())
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBox(context),
            SizedBox(height: 8),
            _buildActionButtons(context),
            SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: GridPreventiviAssegnati(
                        completedTransports: preventiviAssegnati,
                      ),
                    ),
                  ),
                ),
            if (_errorMessage != null) ...[
              SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
      drawer: SideMenuCommittente(),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cerca trasporto...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orange),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
                suffixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              style: TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.calendar_today_outlined, color: Colors.orange),
            onPressed: () => _mostraFiltroDate(context),
            tooltip: 'Filtra Date',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            _richiediOfferte(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
          ),
          child: Text("Richiedi Offerte"),
        ),
        ElevatedButton(
          onPressed: () {
            _vaiARichiesteCancellate(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
          ),
          child: Text("Preventivi Cancellati"),
        ),
      ],
    );
  }

  void _mostraFiltroDate(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
  }

  void _richiediOfferte(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuovaRichiestaSubvezioneScreen(),
      ),
    );
  }

  void _vaiARichiesteCancellate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubvezioniCancellatePage(),
      ),
    );
  }
}
