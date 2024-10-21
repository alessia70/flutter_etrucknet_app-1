import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/anagrafiche_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/marketing_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/messaggi_clienti_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/procedure_screen.dart';

import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/stime.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/ordini.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/camion_disponibili.dart';

import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/nuovo_trasportatore_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/nuovo_committente_screen.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  // Stato per tracciare la pagina selezionata
  String selectedPage = '';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Container(
              alignment: Alignment.center,
              height: 100,  // Altezza ridotta del DrawerHeader
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22, // Ridotto il font size per adattarlo meglio
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          _buildListTile(
            icon: Icons.analytics_outlined,
            title: 'Stime',
            page: 'stime',
            screen: StimeScreen(),
          ),
          _buildListTile(
            icon: Icons.assignment_outlined,
            title: 'Ordini',
            page: 'ordini',
            screen: OrdiniScreen(),
          ),
          _buildListTile(
            icon: Icons.local_shipping_outlined,
            title: 'Camion Disponibili',
            page: 'camion_disponibili',
            screen: AvailableTrucksScreen(),
          ),
          
          ExpansionTile(
            leading: Icon(Icons.person_add_outlined, color: Colors.orange),
            title: Text('Registrati'),
            children: <Widget>[
              _buildListTile(
                icon: Icons.account_circle_outlined,
                title: 'Anagrafiche',
                page: 'anagrafiche',
                screen: AnagraficheGridScreen(),
                isNested: true,
>>>>>>> 66f1e8c60103416a20b43ec7dedd566b35954e36
              ),
              _buildListTile(
                icon: Icons.directions_bus_outlined,
                title: 'Nuovo Trasportatore',
                page: 'nuovo_trasportatore',
                screen: NuovoTrasportatoreScreen(),
                isNested: true,
              ),
              _buildListTile(
                icon: Icons.business_outlined,
                title: 'Nuovo Committente',
                page: 'nuovo_committente',
                screen: NuovoCommittenteScreen(),
                isNested: true,
              ),
            ],
          ),
          
          ExpansionTile(
            leading: Icon(Icons.campaign_outlined, color: Colors.orange),
            title: Text('Marketing'),
            children: <Widget>[
              _buildListTile(
                icon: Icons.insert_chart_outlined,
                title: 'Marketing',
                page: 'marketing',
                screen: MarketingFilesScreen(),
                isNested: true,
>>>>>>> 66f1e8c60103416a20b43ec7dedd566b35954e36
              ),
              _buildListTile(
                icon: Icons.receipt_outlined,
                title: 'Procedure',
                page: 'procedure',
                screen: ProcedureScreen(),
                isNested: true,
              ),
              _buildListTile(
                icon: Icons.message_outlined,
                title: 'Messaggi Clienti',
                page: 'messaggi_clienti',
                screen: MessagesScreen(),
                isNested: true,
>>>>>>> 66f1e8c60103416a20b43ec7dedd566b35954e36
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Funzione helper per creare ListTile con gestione della selezione
  Widget _buildListTile({required IconData icon, required String title, required String page, required Widget screen, bool isNested = false}) {
    return Padding(
      padding: isNested ? const EdgeInsets.only(left: 16.0) : EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title),
        tileColor: selectedPage == page ? Colors.grey[300] : null,  // Sfondo grigio se selezionato
        onTap: () {
          setState(() {
            selectedPage = page;  // Aggiorniamo la pagina selezionata
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
