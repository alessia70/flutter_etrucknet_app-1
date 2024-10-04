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
    // Aggiungi altre anagrafiche qui
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
                // Dati Anagrafica (Colonna Sinistra)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ID
                      Text(
                        'ID: ${anagrafica['id']}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),

                      // Nome Utente e Icona per Contatto
                      Row(
                        children: [
                          Text(
                            'Nome: ${anagrafica['nome']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: Icon(Icons.email_outlined, color: Colors.blue),
                            onPressed: () {
                              _contactUser(anagrafica['email']);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Località e Provincia
                      Text(
                        'Località: ${anagrafica['localita']} (${anagrafica['provincia']})',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),

                      // Ruolo
                      Text(
                        'Ruolo: ${anagrafica['ruolo']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),

                      // Tipo di Contratto
                      Text(
                        'Contratto: ${anagrafica['contratto']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),

                      // Ordini e Quotazioni
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

                // Bottoni Azione (Colonna Destra)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Bottone 1 (Da Implementare)
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        // Logica per il primo bottone
                      },
                    ),

                    // Bottone 2 (Da Implementare)
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Logica per il secondo bottone
                      },
                    ),

                    // Bottone 3 (Da Implementare)
                    IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.blue),
                      onPressed: () {
                        // Logica per il terzo bottone
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
    // Logica per contattare l'utente via email (puoi usare package come url_launcher)
    print('Contattare l\'utente via email: $email');
  }
}
