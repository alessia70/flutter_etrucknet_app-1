import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilo'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.orange,
            onPressed: () {
              // Funzionalità per modificare il profilo
              // Puoi implementare una pagina per modificare i dati utente qui
              // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informazioni Personali',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Simulazione di dati utente
            ListTile(
              title: const Text('Nome:'),
              subtitle: const Text('Mario Rossi'),
            ),
            ListTile(
              title: const Text('Email:'),
              subtitle: const Text('m.rossi@example.com'),
            ),
            ListTile(
              title: const Text('Telefono:'),
              subtitle: const Text('+39 123 456 7890'),
            ),
            const Divider(),
            const Text(
              'Impostazioni Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Cambia Password'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Implementa la funzionalità per cambiare la password
              },
            ),
            ListTile(
              title: const Text('Esci'),
              trailing: const Icon(Icons.logout),
              onTap: () {
                // Implementa la funzionalità di logout
              },
            ),
          ],
        ),
      ),
    );
  }
}
