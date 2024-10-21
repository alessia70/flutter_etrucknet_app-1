import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_etrucknet_new/Models/order_model.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/add_ordine.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/data_grid_ordini.dart';

class OrdiniScreen extends StatefulWidget {
  const OrdiniScreen({super.key});

  @override
  _OrdiniScreenState createState() => _OrdiniScreenState();
}

class _OrdiniScreenState extends State<OrdiniScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedOption = 'Tutti'; // Valore iniziale per il dropdown
  DateTimeRange? _selectedDateRange; // Valore per il selettore di date

  // Esempio di lista di ordini
  final List<Order> orders = List.generate(10, (index) {
    return Order(
      id: '${index + 1}',
      customerName: 'Cliente_${index + 1}',
      customerContact: 'Contatto_${index + 1}',
      date: DateTime.now().subtract(Duration(days: index)), // Data decrescente
      companyName: 'Azienda_${index + 1}',
      loadingDate: '2024-10-10',
      loadingLocation: 'Luogo_${index + 1}',
      loadingProvince: 'Provincia_${index + 1}',
      loadingCountry: 'Nazione_${index + 1}',
      isLoadingMandatory: index % 2 == 0,
      unloadingDate: '2024-10-15',
      unloadingLocation: 'Luogo_${index + 2}',
      unloadingProvince: 'Provincia_${index + 2}',
      unloadingCountry: 'Nazione_${index + 2}',
      offerAmount: (index + 1) * 100.0,
      activeOffers: 5 - index,
      expiredOffers: index,
      correspondenceCount: 3,
      estimatedBudget: (index + 1) * 1000.0,
    );
  });

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestione Ordini'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
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
                    setState(() {
                      // Logica per aggiornare i risultati della ricerca
                    });
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
                          prefixIcon: Icon(Icons.calendar_today, color: Colors.orange,),
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
            child: OrdersGrid(orders: orders),
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
