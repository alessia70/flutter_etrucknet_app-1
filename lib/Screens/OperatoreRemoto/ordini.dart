import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_etrucknet_new/Models/order_model.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/add_ordine.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/data_grid_ordini.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/side_menu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrdiniScreen extends StatefulWidget {
  const OrdiniScreen({super.key});

  @override
  _OrdiniScreenState createState() => _OrdiniScreenState();
}

class _OrdiniScreenState extends State<OrdiniScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedOption = 'Tutti';
  DateTimeRange? _selectedDateRange;
  List<Order> orders = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }
  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('trasportatore_id');
  }

  Future<Map<String, dynamic>> _getTokenAndTransporterId() async {
    final token = await getSavedToken();
    final transporterId = await getSavedUserId();

    if (token == null || transporterId == null) {
      print("Token o ID trasportatore non trovato.");
      return {};
    }

    return {'token': token, 'transporterId': transporterId};
  }

  List<Order> parseOrders(String responseBody) {
    try {
      final parsed = json.decode(responseBody);

      if (parsed is List) {
        return parsed.map<Order>((json) => Order.fromJson(json)).toList();
      } else if (parsed is Map) {
        print("Risposta non prevista: ${parsed.toString()}");
        return [];
      } else {
        print("Formato di risposta non valido");
        return [];
      }
    } catch (e) {
      print('Errore nel parsing dei dati: $e');
      return [];
    }
  }

  Future<void> _fetchOrders() async {
    final tokenAndId = await _getTokenAndTransporterId();
    final token = tokenAndId['token'];
    final transporterId = tokenAndId['transporterId'];

    if (token == null || transporterId == null) {
      print("Impossibile fare la richiesta, mancano i dati.");
      return;
    }

    DateTimeRange dateRange = _selectedDateRange ??
        DateTimeRange(
          start: DateTime(2000, 01, 01),
          end: DateTime(2100, 01, 01),
        );

    String url = 'https://etrucknetapi.azurewebsites.net/v1/Proposte/8324'
        '?TrasportatoreId=$transporterId'
        '&inviato=true'
        '&latitudineCarico='
        '&longitudineCarico='
        '&latitudineScarico='
        '&longitudineScarico='
        '&Tolleranza='
        '&AllestimentoSelezionato=Tutti'
        '&dataInizio=${dateRange.start.toIso8601String()}'
        '&dataFine=${dateRange.end.toIso8601String()}';

    print("URL richiesto: $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Risposta ricevuta: ${response.body}');

      if (response.statusCode == 200) {
        try {
          setState(() {
            orders = parseOrders(response.body);
            _isLoading = false;
          });
        } catch (e) {
          setState(() {
            _errorMessage = 'Errore nel parsing dei dati: $e';
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = "Errore di autenticazione. Verifica il token.";
          _isLoading = false;
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
  List<Order> _filterOrders() {
    return orders.where((order) {
      final matchesSearch = _searchController.text.isEmpty ||
          order.customerName
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
      final matchesStatus = _selectedOption == 'Tutti' ||
          (_selectedOption == 'In Corso' && order.isCompleted != true) ||
          (_selectedOption == 'Completati' && order.isCompleted == true) ||
          (_selectedOption == 'Annullati' && order.isCanceled == true);

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _isLoading = true;
      });
      _fetchOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _filterOrders();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestione Ordini'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      drawer: SideMenu(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Cerca ordini',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedOption,
                                  items: ['Tutti', 'In Corso', 'Completati', 'Annullati']
                                      .map((String option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    labelText: 'Filtra per stato',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedOption = newValue!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Seleziona periodo',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.calendar_today, color: Colors.orange),
                                  ),
                                  onTap: () => _selectDateRange(context),
                                  controller: TextEditingController(
                                    text: _selectedDateRange == null
                                        ? ''
                                        : '${_selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${_selectedDateRange!.end.toLocal().toString().split(' ')[0]}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: OrdersGrid(orders: filteredOrders),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newOrder = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddOrdineScreen(),
            ),
          );

          if (newOrder != null && newOrder is Order) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              setState(() {
                orders.add(newOrder);
              });
            });
          }
        },
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        child: Icon(Icons.add_rounded, size: 30),
      ),
    );
  }
}