import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:flutter_etrucknet_new/Widgets/add_new_message.dart';
import 'package:flutter_etrucknet_new/Widgets/side_menu.dart';
import 'package:intl/intl.dart';
import 'package:flutter_etrucknet_new/Widgets/messaggi_grid.dart'; 

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchUserController = TextEditingController();
  final TextEditingController _searchMessageController = TextEditingController();
  DateTime? _selectedDateFrom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messaggi Clienti'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const ProfilePage()
                )
              );
            },
          ),
        ],
      ),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchUserController,
              decoration: InputDecoration(
                labelText: 'Cerca Utente',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchMessageController,
              decoration: InputDecoration(
                labelText: 'Cerca Messaggio',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Filtra per Data',
                      border: OutlineInputBorder(),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.calendar_today, color: Colors.orange),
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDateFrom ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (picked != null) {
                            setState(() {
                              _selectedDateFrom = picked;
                            });
                          }
                        },
                      ),
                    ),
                    controller: TextEditingController(
                      text: _selectedDateFrom != null
                          ? DateFormat('dd/MM/yyyy').format(_selectedDateFrom!)
                          : '',
                    ),
                  ),
                ),
                SizedBox(width: 130),
                ElevatedButton(
                  onPressed: () {
                    print('Cerca per: ${_searchUserController.text} e Messaggio: ${_searchMessageController.text}');
                  },
                  child: Text(
                    'Cerca',
                    style: TextStyle(color: Colors.orange),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange,
                    side: BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: MessaggiGrid(),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMessageScreen()), 
          );
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
