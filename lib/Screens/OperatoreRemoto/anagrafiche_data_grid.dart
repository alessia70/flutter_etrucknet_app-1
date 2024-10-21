import 'package:flutter/material.dart';

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

                // Colonna per i pulsanti di modifica, eliminazione e informazioni
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Modifica qui
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        // Azione per modifica
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Azione per eliminare
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.green),
                      onPressed: () {
                        // Azione per mostrare informazioni
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
    print('Contattare l\'utente via email: $email');
  }
}
