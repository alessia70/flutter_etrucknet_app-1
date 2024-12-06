import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/profile_menu_t_screen.dart';
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
            _buildAutistiCards(),
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

  Widget _buildAutistiCards() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: autistiList.length,
        itemBuilder: (context, index) {
          final autista = autistiList[index];
          return SizedBox(
            height: 220,
            child:  Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${autista['nome']} ${autista['cognome']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    Center(
                      child: Icon(
                        Icons.person_3_outlined,
                        size: 60,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.grey[300], thickness: 0.5),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            autista['telefono'] ?? '',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.email, size: 16, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            autista['email'] ?? '',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            _showAddOrEditAutistaDialog(
                              cognome: autista['cognome'],
                              nome: autista['nome'],
                              telefono: autista['telefono'],
                              email: autista['email'],
                            );
                          },
                          tooltip: 'Modifica',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              autistiList.removeAt(index);
                            });
                          },
                          tooltip: 'Elimina',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
