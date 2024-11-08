import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/side_menu_t.dart';

class AutistiPage extends StatefulWidget {
  @override
  _AutistiPageState createState() => _AutistiPageState();
}

class _AutistiPageState extends State<AutistiPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, String>> autistiList = [
    {'cognome': 'Rossi', 'nome': 'Mario', 'telefono': '1234567890', 'email': 'mario.rossi@example.com'},
    {'cognome': 'Bianchi', 'nome': 'Luigi', 'telefono': '0987654321', 'email': 'luigi.bianchi@example.com'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Autisti'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
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
            _buildAutistiTable(),
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
              labelText: 'Cerca autista',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.add, color: Colors.orange),
          onPressed: () {
            _showAddOrEditAutistaDialog();
          },
        ),
      ],
    );
  }

  Widget _buildAutistiTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tabella degli Autisti',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Cognome')),
                  DataColumn(label: Text('Nome')),
                  DataColumn(label: Text('Telefono')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Azioni')),
                ],
                rows: autistiList.map((autista) {
                  return _buildDataRow(
                    autista['cognome']!,
                    autista['nome']!,
                    autista['telefono']!,
                    autista['email']!,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String cognome, String nome, String telefono, String email) {
    return DataRow(cells: [
      DataCell(Text(cognome)),
      DataCell(Text(nome)),
      DataCell(Text(telefono)),
      DataCell(Text(email)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.orange),
            onPressed: () {
              _showAddOrEditAutistaDialog(
                cognome: cognome,
                nome: nome,
                telefono: telefono,
                email: email,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.grey),
            onPressed: () {
              setState(() {
                autistiList.removeWhere((autista) => autista['telefono'] == telefono);
              });
            },
          ),
        ],
      )),
    ]);
  }

  void _showAddOrEditAutistaDialog({String? cognome, String? nome, String? telefono, String? email}) {
    final TextEditingController cognomeController = TextEditingController(text: cognome);
    final TextEditingController nomeController = TextEditingController(text: nome);
    final TextEditingController telefonoController = TextEditingController(text: telefono);
    final TextEditingController emailController = TextEditingController(text: email);

    bool isEditing = cognome != null && nome != null && telefono != null && email != null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.person, color: Colors.orange),
              SizedBox(width: 8),
              Text(isEditing ? 'Modifica Autista' : 'Aggiungi Autista', style: TextStyle(color: Colors.orange)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cognomeController,
                  decoration: InputDecoration(labelText: 'Cognome*'),
                ),
                TextField(
                  controller: nomeController,
                  decoration: InputDecoration(labelText: 'Nome*'),
                ),
                TextField(
                  controller: telefonoController,
                  decoration: InputDecoration(labelText: 'Telefono*'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email*'),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annulla', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                if (cognomeController.text.isNotEmpty &&
                    nomeController.text.isNotEmpty &&
                    telefonoController.text.isNotEmpty &&
                    emailController.text.isNotEmpty) {
                  setState(() {
                    if (isEditing) {
                      // Update existing driver
                      final index = autistiList.indexWhere((autista) => autista['telefono'] == telefono);
                      if (index != -1) {
                        autistiList[index] = {
                          'cognome': cognomeController.text,
                          'nome': nomeController.text,
                          'telefono': telefonoController.text,
                          'email': emailController.text,
                        };
                      }
                    } else {
                      // Add new driver
                      autistiList.add({
                        'cognome': cognomeController.text,
                        'nome': nomeController.text,
                        'telefono': telefonoController.text,
                        'email': emailController.text,
                      });
                    }
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Per favore, compila tutti i campi obbligatori.')),
                  );
                }
              },
              child: Text('Salva', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }
}
