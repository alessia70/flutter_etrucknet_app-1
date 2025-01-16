import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/Registrati/modifca_anagrafiche_screen.dart';

class AnagraficheDataGrid extends StatelessWidget {
  final List<Map<String, dynamic>> anagrafiche = [
    {
      'id': '001',
      'nome': 'Mario Rossi',
      'localita': 'Milano',
      'provincia': 'MI',
      'ruolo': 'Cliente',
      'contratto': 'Annuale',
      'ordini': 5,
      'quotazioni': 10,
      'email': 'mario.rossi@example.com',
    },
    {
      'id': '002',
      'nome': 'Luca Bianchi',
      'localita': 'Roma',
      'provincia': 'RM',
      'ruolo': 'Fornitore',
      'contratto': 'Semestrale',
      'ordini': 2,
      'quotazioni': 8,
      'email': 'luca.bianchi@example.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: anagrafiche.length,
      itemBuilder: (context, index) {
        final anagrafica = anagrafiche[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${anagrafica['id']}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _contactUser(anagrafica['email']);
                            },
                            child: Icon(Icons.email_outlined, color: Colors.deepOrange),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${anagrafica['nome']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Località: ${anagrafica['localita']} (${anagrafica['provincia']})',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ruolo: ${anagrafica['ruolo']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Contratto: ${anagrafica['contratto']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Ordini: ${anagrafica['ordini']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Quotazioni: ${anagrafica['quotazioni']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModifyAnagraficaScreen(
                              anagrafica: anagrafica, // Passiamo i dati qui
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.mail_outlined, color: Colors.red),
                      onPressed: () {
                        _inviaCredenziali(context, anagrafica);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.rate_review_outlined, color: Colors.green),
                      onPressed: () {
                         _showRatingDialog(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _contactUser(String email) {
    log('Contattare l\'utente via email: $email');
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Valutazione Anagrafica'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Generato da'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Data inizio'),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Data fine'),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Descrizione'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Fido'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Note'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialogo
              },
              child: const Text('Indietro', style: TextStyle(color:Colors.orange)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialogo
              },
              child: const Text('Invia', style: TextStyle(color:Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _inviaCredenziali(BuildContext context, Map<String, dynamic> anagrafica) async {
    // Simula una chiamata API
    bool invioRiuscito = await _simulaInvioCredenziali(anagrafica);

    // Mostra un pop-up in base al risultato
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(invioRiuscito ? 'Invio riuscito' : 'Errore di invio'),
          content: Text(
            invioRiuscito
                ? 'Le credenziali sono state inviate correttamente a ${anagrafica['nome']}.'
                : 'C\'è stato un errore durante l\'invio delle credenziali.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiude il dialog
              },
              child: Text('OK', style: TextStyle(color:Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  // Funzione simulata per l'invio credenziali (potrebbe essere un'API call reale)
  Future<bool> _simulaInvioCredenziali(Map<String, dynamic> anagrafica) async {
    await Future.delayed(Duration(seconds: 2)); // Simula un ritardo
    return true; // Restituisce true se invio riuscito, false se fallito
  }
}
