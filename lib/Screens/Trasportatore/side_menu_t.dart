import 'package:flutter/material.dart';

class SideMenuT extends StatefulWidget {
  @override
  _SideMenuTState createState() => _SideMenuTState();
}

class _SideMenuTState extends State<SideMenuT> {
  // Variabili per gestire l'espansione delle voci
  bool _isConfigurationExpanded = false;
  bool _isSalesExpanded = false;
  bool _isPurchaseExpanded = false;
  bool _isAdministrationExpanded = false;

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
              'Etrucknet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildExpandableTile(
            title: 'Configurazione',
            children: [
              _buildListTile('Flotta'),
              _buildListTile('Tratte'),
              _buildListTile('Servizi Logistici'),
              _buildListTile('Camion Disponibili'),
              _buildListTile('Autisti'),
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
            children: [
              _buildListTile('Trasporti a te Proposti'),
              _buildListTile('Tutti i Trasporti'),
              _buildListTile('Trasporti Eseguiti'),
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
            children: [
              _buildListTile('Richieste Sub-vezioni'),
              _buildListTile('Conferme Sub-vezioni'),
              _buildListTile('Sub-vezioni Cancellate'),
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
            children: [
              _buildListTile('Fatture Emesse'),
              _buildListTile('Fatture Ricevute'),
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
    required List<Widget> children,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
  }) {
    return ExpansionTile(
      title: Text(title),
      children: children,
      onExpansionChanged: onExpansionChanged,
      initiallyExpanded: isExpanded,
    );
  }

  Widget _buildListTile(String title) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        switch (title) {
          case 'Flotta':
            Navigator.pushNamed(context, 'Configurazione/flotta');
            break;
          case 'Tratte':
            Navigator.pushNamed(context, 'Configurazione/tratte');
            break;
          case 'Servizi Logistici':
            Navigator.pushNamed(context, 'Configurazione/servizi_logistici');
            break;
          case 'Camion Disponibili':
            Navigator.pushNamed(context, 'Configurazione/camion_disponibili_t');
            break;
          case 'Autisti':
            Navigator.pushNamed(context, 'Configurazione/autisti');
            break;
          case 'Trasporti a te Proposti':
            break;
          case 'Tutti i Trasporti':
            break;
          case 'Trasporti Eseguiti':
            break;
          case 'Richieste Sub-vezioni':
            break;
          case 'Conferme Sub-vezioni':
            break;
          case 'Sub-vezioni Cancellate':
            break;
          case 'Fatture Emesse':
            break;
          case 'Fatture Ricevute':
            break;
        }
      },
    );
  }
}
