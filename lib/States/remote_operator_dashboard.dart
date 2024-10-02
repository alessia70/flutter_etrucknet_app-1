import 'package:flutter/material.dart';

class RemoteOperatorDashboard extends StatelessWidget {
  const RemoteOperatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Operatore Remoto'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Text(
                'Menu Operatore',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                // Naviga alla home o altre azioni
              },
            ),
            // Aggiungi altre voci di menu se necessario
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Benvenuto!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
