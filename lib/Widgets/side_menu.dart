import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/marketing_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/messaggi_clienti_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/procedure_screen.dart';

import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/stime.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/ordini.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/camion_disponibili.dart';


import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/nuovo_trasportatore_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/nuovo_committente_screen.dart';
import 'package:flutter_etrucknet_new/Screens/anagrafiche_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

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
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),

          ListTile(
            title: Text('Stime'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StimeScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Ordini'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdiniScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Camion Disponibili'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AvailableTrucksScreen()),
              );
            },
          ),

          ExpansionTile(
            title: Text('Registrati'),
            children: <Widget>[
               Padding(
                padding: const EdgeInsets.only(left: 16.0), 
                child: ListTile(
                  title: Text('Anagrafiche'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnagraficheScreen()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Nuovo Trasportatore'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NuovoTrasportatoreScreen()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0), 
                child: ListTile(
                  title: Text('Nuovo Committente'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NuovoCommittenteScreen()),
                    );
                  },
                ),
              )
            ],
          ),
          ExpansionTile(
            title: Text('Marketing'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0), 
                child: ListTile(
                  title: Text('Marketing'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MarketingScreen()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  title: Text('Procedure'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProcedureScreen()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0), 
                child: ListTile(
                  title: Text('Messaggi Clienti'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MessaggiClientiScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
