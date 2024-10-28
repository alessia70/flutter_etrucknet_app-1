import 'package:flutter/material.dart';

class SideMenuT extends StatefulWidget {
  @override
  _SideMenuTState createState() => _SideMenuTState();
}

class _SideMenuTState extends State<SideMenuT> {
  bool _isConfigurationExpanded = false;
  bool _isSalesExpanded = false;
  bool _isPurchaseExpanded = false;
  bool _isAdministrationExpanded = false;
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
                'Menu Trasportatore',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
    bool isSelected = selectedPage == title; // Controlla se è selezionato
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.orange : Colors.grey), // Cambia colore
        title: Text(title),
        tileColor: isSelected ? Colors.grey[300] : null, // Cambia colore dello sfondo
        onTap: () {
          setState(() {
            selectedPage = title; // Aggiorna la pagina selezionata
          });
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
              Navigator.pushNamed(context, 'vendita_trasporti/proposti');
              break;
            case 'Tutti i Trasporti':
              Navigator.pushNamed(context, 'vendita_trasporti/tutti');
              break;
            case 'Trasporti Eseguiti':
              Navigator.pushNamed(context, 'vendita_trasporti/eseguiti');
              break;
            case 'Richieste Sub-vezioni':
              Navigator.pushNamed(context, 'acquisto_trasporti/richieste');
              break;
            case 'Conferme Sub-vezioni':
              Navigator.pushNamed(context, 'acquisto_trasporti/conferme');
              break;
            case 'Sub-vezioni Cancellate':
              Navigator.pushNamed(context, 'acquisto_trasporti/cancellate');
              break;
            case 'Fatture Emesse':
              Navigator.pushNamed(context, 'amministrazione/fatture_emesse');
              break;
            case 'Fatture Ricevute':
              Navigator.pushNamed(context, 'amministrazione/fatture_ricevute');
              break;
          }
        },
      ),
    );
  }
}
