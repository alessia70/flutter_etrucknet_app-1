import 'dart:developer';

import 'package:flutter/material.dart';

class SideMenuCommittente extends StatefulWidget {
  const SideMenuCommittente({super.key});

  @override
  _SideMenuCommittenteState createState() => _SideMenuCommittenteState();
}

class _SideMenuCommittenteState extends State<SideMenuCommittente> {
  bool _isConfigurationExpanded = false;
  bool _isSalesExpanded = false;
  bool _isAdministrationExpanded = false;
  String selectedPage = '';

  final Map<String, String> routes = {
    'Bacheca': '/dashboard_committente',
    'Simula costo': '/Simulatore/simula_costo_page',
    'Simulazioni': '/Simulatore/mie_simulazioni_page',
    'Richiedi preventivo': '/Trasporti/richiedi_preventivo_page',
    'Preventivi richiesti': '/Trasporti/preventivi_richiesti_page',
    'Preventivi assegnati': '/Trasporti/preventivi_assegnati_page',
    'Preventivi cancellati': '/Trasporti/preventivi_cancellati_page',
    'Fatture ricevute': '/Amministrazione/fatture_ricevute_committente_page',
  };

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
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.orange),
            title: Text('Bacheca'),
            tileColor: selectedPage == 'Bacheca' ? Colors.grey[300] : null,
            onTap: () {
              setState(() {
                selectedPage = 'Bacheca';
              });
              Navigator.pop(context);
              Navigator.pushNamed(context, routes['Bacheca']!);
            },
          ),
          _buildExpandableTile(
            title: 'Simulatore',
            icon: Icons.settings,
            children: [
              _buildIndentedListTile('Simula costo', Icons.calculate_outlined),
              _buildIndentedListTile('Simulazioni', Icons.map),
            ],
            isExpanded: _isConfigurationExpanded,
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isConfigurationExpanded = expanded;
              });
            },
          ),
          _buildExpandableTile(
            title: 'Trasporti',
            icon: Icons.local_shipping,
            children: [
              _buildIndentedListTile('Richiedi preventivo', Icons.assignment),
              _buildIndentedListTile('Preventivi richiesti', Icons.list),
              _buildIndentedListTile('Preventivi assegnati', Icons.done),
              _buildIndentedListTile('Preventivi cancellati', Icons.delete),
            ],
            isExpanded: _isSalesExpanded,
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isSalesExpanded = expanded;
              });
            },
          ),
          _buildExpandableTile(
            title: 'Amministrazione',
            icon: Icons.admin_panel_settings,
            children: [
              _buildIndentedListTile('Fatture ricevute', Icons.download),
            ],
            isExpanded: _isAdministrationExpanded,
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isAdministrationExpanded = expanded;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableTile({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      onExpansionChanged: onExpansionChanged,
      initiallyExpanded: isExpanded,
      children: children,
    );
  }

  Widget _buildIndentedListTile(String title, IconData icon) {
    bool isSelected = selectedPage == title; 
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.orange : Colors.grey),
        title: Text(title),
        tileColor: isSelected ? Colors.grey[300] : null, 
        onTap: () {
          setState(() {
            selectedPage = title;
          });
          Navigator.pop(context);
          
          final route = routes[title];
          if (route != null) {
            Navigator.pushNamed(context, route);
          } else {
            log('Route not found for $title');
          }
        },
      ),
    );
  }
}
