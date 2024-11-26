import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/Registrati/anagrafiche_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/Marketing/marketing_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/Marketing/messaggi_clienti_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/Marketing/procedure_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/stime.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/ordini.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/camion_disponibili.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/Registrati/nuovo_trasportatore_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/Registrati/nuovo_committente_screen.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
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
              height: 100,
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
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
            leading: Icon(
              Icons.person_add_outlined,
              color: selectedPage.startsWith('registrati') ? Colors.orange : Colors.grey,
            ),
            title: Text('Registrati'),
            children: <Widget>[
              _buildListTile(
                icon: Icons.account_circle_outlined,
                title: 'Anagrafiche',
                page: 'anagrafiche',
                screen: AnagraficheGridScreen(),
                isNested: true,
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
            leading: Icon(
              Icons.campaign_outlined,
              color: selectedPage.startsWith('marketing') ? Colors.orange : Colors.grey,
            ),
            title: Text('Marketing'),
            children: <Widget>[
              _buildListTile(
                icon: Icons.insert_chart_outlined,
                title: 'Marketing',
                page: 'marketing',
                screen: MarketingFilesScreen(),
                isNested: true,
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({required IconData icon, required String title, required String page, required Widget screen, bool isNested = false}) {
    return Padding(
      padding: isNested ? const EdgeInsets.only(left: 16.0) : EdgeInsets.zero,
      child: ListTile(
        leading: Icon(
          icon,
          color: selectedPage == page ? Colors.orange : Colors.grey,
        ),
        title: Text(title),
        tileColor: selectedPage == page ? Colors.grey[300] : null, 
        onTap: () {
          setState(() {
            selectedPage = page;
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
