import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/order_model.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/add_ordine.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/side_menu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'data_grid_ordini.dart';

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
      setState(() {
        _errorMessage = 'Token o ID trasportatore non trovato. Verifica i dati.';
        _isLoading = false;
      });
      return {};
    }
    return {'token': token, 'transporterId': transporterId};
  }

  List<Order> parseOrders(String responseBody) {
    try {
      final parsed = json.decode(responseBody);
      print('Parsed response: $parsed');  // Stampa l'intero JSON per vedere cosa stiamo ricevendo

      if (parsed is Map<String, dynamic> && parsed['data'] is List) {
        List<Order> orders = (parsed['data'] as List)
            .map<Order>((json) => Order.fromJson(json))
            .toList();

        orders.forEach((order) {
          print("Ordine ID: ${order.id}, Cliente: ${order.customerName}, Offerta: ${order.offerAmount}");
        });

        return orders;
      } else {
        print('Errore: risposta non in formato lista o chiave "data" mancante');
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
      setState(() {
        _errorMessage = 'Token o ID trasportatore non trovato. Verifica i dati.';
        _isLoading = false;
      });
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
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        setState(() {
          orders = parseOrders(response.body);
          _isLoading = false;
          if (orders.isEmpty) {
            _errorMessage = 'Nessun ordine trovato.';
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

  List<Order> _filterOrders() {
    final filtered = orders.where((order) {
      final matchesSearch = _searchController.text.isEmpty ||
          order.customerName.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesStatus = _selectedOption == 'Tutti' ||
          (_selectedOption == 'In Corso' && order.isCompleted != true) ||
          (_selectedOption == 'Completati' && order.isCompleted == true) ||
          (_selectedOption == 'Annullati' && order.isCanceled == true);

      return matchesSearch && matchesStatus;
    }).toList();

    return filtered;
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

  void _handleDeleteOrder(Order order) {
    setState(() {
      orders.removeWhere((o) => o.id == order.id);
    });
  }

  void _handleUpdateOrder(Order updatedOrder) {
    setState(() {
      int index = orders.indexWhere((o) => o.id == updatedOrder.id);
      if (index != -1) {
        orders[index] = updatedOrder;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _filterOrders();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestione Ordini'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      drawer: const SideMenu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Cerca ordini',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
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
                        decoration: const InputDecoration(
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
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: const InputDecoration(
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : orders.isEmpty
                        ? const Center(child: Text('Nessun ordine disponibile.'))
                        : OrdersGrid(
                            orders: orders,
                            onDeleteOrder: _handleDeleteOrder,
                            onUpdateOrder: _handleUpdateOrder,
                        ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newOrder = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddOrdineScreen(),
            ),
          );
          if (newOrder != null && newOrder is Order) {
            setState(() {
              orders.add(newOrder);
            });
          }
        },
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    );
  }
}
