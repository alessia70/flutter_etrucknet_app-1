import 'dart:developer';

import 'package:flutter/material.dart';

class SideMenuT extends StatefulWidget {
  const SideMenuT({super.key});

  @override
  _SideMenuTState createState() => _SideMenuTState();
}

class _SideMenuTState extends State<SideMenuT> {
  bool _isConfigurationExpanded = false;
  bool _isSalesExpanded = false;
  bool _isPurchaseExpanded = false;
  bool _isAdministrationExpanded = false;
  String selectedPage = '';

  final Map<String, String> routes = {
    'Bacheca': '/dashboard_trasportatore',
    'Flotta': '/Configurazione/flotta',
    'Tratte': '/Configurazione/tratte',
    'Servizi Logistici': '/Configurazione/servizi_logistici',
    'Camion Disponibili': '/Configurazione/camion_disponibili_t',
    'Autisti': '/Configurazione/autisti',
    'Trasporti a te Proposti': '/VenditaTrasporti/proposte_trasporti',
    'Tutti i Trasporti': '/VenditaTrasporti/totale_trasporti',
    'Trasporti Eseguiti': '/VenditaTrasporti/trasporti_eseguiti',
    'Richieste Sub-vezioni': '/AcquistoTrasporti/richieste_subvezioni_page',
    'Conferme Sub-vezioni': '/AcquistoTrasporti/conferme_subvezioni_page',
    'Sub-vezioni Cancellate': '/AcquistoTrasporti/subvezioni_cancellate_page',
    'Fatture Emesse': '/Amministrazione/fatture_emesse_page',
    'Fatture Ricevute': '/Amministrazione/fatture_ricevute_page',
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
            title: 'Configurazione',
            icon: Icons.settings,
            children: [
              _buildIndentedListTile('Flotta', Icons.directions_car),
              _buildIndentedListTile('Tratte', Icons.map),
              _buildIndentedListTile('Servizi Logistici', Icons.business),
              _buildIndentedListTile('Camion Disponibili', Icons.local_shipping),
              _buildIndentedListTile('Autisti', Icons.person),
            ],
            isExpanded: _isConfigurationExpanded,
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isConfigurationExpanded = expanded;
              });
            },
          ),
          _buildExpandableTile(
            title: 'Vendita Trasporti',
            icon: Icons.local_shipping,
            children: [
              _buildIndentedListTile('Trasporti a te Proposti', Icons.assignment),
              _buildIndentedListTile('Tutti i Trasporti', Icons.list),
              _buildIndentedListTile('Trasporti Eseguiti', Icons.done),
            ],
            isExpanded: _isSalesExpanded,
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isSalesExpanded = expanded;
              });
            },
          ),
          _buildExpandableTile(
            title: 'Acquisto Trasporti',
            icon: Icons.shopping_cart,
            children: [
              _buildIndentedListTile('Richieste Sub-vezioni', Icons.inbox),
              _buildIndentedListTile('Conferme Sub-vezioni', Icons.check_circle),
              _buildIndentedListTile('Sub-vezioni Cancellate', Icons.cancel),
            ],
            isExpanded: _isPurchaseExpanded,
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isPurchaseExpanded = expanded;
              });
            },
          ),
          _buildExpandableTile(
            title: 'Amministrazione',
            icon: Icons.admin_panel_settings,
            children: [
              _buildIndentedListTile('Fatture Emesse', Icons.upload_file),
              _buildIndentedListTile('Fatture Ricevute', Icons.download),
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
      children: children,
      onExpansionChanged: onExpansionChanged,
      initiallyExpanded: isExpanded,
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
