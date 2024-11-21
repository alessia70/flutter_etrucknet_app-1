import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/profile_menu_t_screen.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/side_menu_t.dart';

class ServiziLogisticiPage extends StatefulWidget {
  @override
  _ServiziLogisticiPageState createState() => _ServiziLogisticiPageState();
}

class _ServiziLogisticiPageState extends State<ServiziLogisticiPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedServizio;
  TextEditingController localitaController = TextEditingController();

  final List<String> serviziOptions = ['Noleggio', 'Sollevamenti', 'Operatore Doganale'];

  List<Map<String, String>> servizi = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Servizi Logistici'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 16),
            _buildServiziTable(),
            SizedBox(height: 16),
          ],
        ),
      ),
      drawer: SideMenuT(),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Cerca servizi',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.add, color: Colors.orange),
          onPressed: () {
            _showAddServiceDialog();
          },
        ),
      ],
    );
  }

  Widget _buildServiziTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tabella dei Servizi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Servizio')),
                  DataColumn(label: Text('Località')),
                  DataColumn(label: Text('Azione')),
                ],
                rows: servizi
                    .map((servizio) => DataRow(cells: [
                          DataCell(Text(servizio['servizio']!)),
                          DataCell(Text(servizio['localita']!)),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange),
                                onPressed: () {
                                
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.grey),
                                onPressed: () {
                                
                                },
                              ),
                            ],
                          )),
                        ]))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aggiungi Servizio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Seleziona Tipo di Servizio', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: selectedServizio,
                hint: Text('Seleziona servizio'),
                onChanged: (value) {
                  setState(() {
                    selectedServizio = value;
                  });
                },
                items: serviziOptions.map((servizio) {
                  return DropdownMenuItem<String>(
                    value: servizio,
                    child: Text(servizio),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              Text('Inserisci Località', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: localitaController,
                decoration: InputDecoration(
                  hintText: 'Inserisci località',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ANNULLA', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                if (selectedServizio != null && localitaController.text.isNotEmpty) {
                  setState(() {
                    servizi.add({
                      'servizio': selectedServizio!,
                      'localita': localitaController.text,
                    });
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Seleziona il servizio e inserisci la località')),
                  );
                }
              },
              child: Text('SALVA', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }
}
