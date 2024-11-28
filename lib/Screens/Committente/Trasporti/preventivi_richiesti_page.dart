import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/dettagli_preventivo.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/profile_menu_committente.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/side_menu_committente.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/AcquistoTrasporti/nuova_richieste_subvezioni_page.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/AcquistoTrasporti/subvezioni_cancellate_page.dart';

class PreventiviRichiestiPage extends StatefulWidget {
  @override
  _PreventiviRichiestiPageState createState() => _PreventiviRichiestiPageState();
}

class _PreventiviRichiestiPageState extends State<PreventiviRichiestiPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, String>> preventiviRichiesti = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Preventivi Richiesti'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const ProfileCommittentePage()
                )
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBox(context),
            SizedBox(height: 8),
            _buildActionButtons(context),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: preventiviRichiesti.length,
                itemBuilder: (context, index) {
                  return _buildPreventivoCard(preventiviRichiesti[index]);
                },
              ),
            ),
          ],
        ),
      ),
      drawer: SideMenuCommittente(),
    );
  }
  Widget _buildPreventivoCard(Map<String, String> preventivo) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID Ordine: ${preventivo['id']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Ritiro: ${preventivo['localitaRitiro']}'),
            Text('Consegna: ${preventivo['localitaConsegna']}'),
            Text('Data Ritiro: ${preventivo['dataRitiro']}'),
            Text('Data Consegna: ${preventivo['dataConsegna']}'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOutlinedIconButton(
                  icon: Icons.info_outline,
                  tooltip: 'Dettagli',
                  onPressed: () => _vaiADettagliPreventivo(preventivo),
                ),
                _buildOutlinedIconButton(
                  icon: Icons.delete_outline,
                  tooltip: 'Elimina',
                  onPressed: () => _eliminaPreventivo(preventivo),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOutlinedIconButton(
                  icon: Icons.message_outlined,
                  tooltip: 'Messaggi',
                  onPressed: () => _vaiAMessaggiClienti(preventivo),
                ),
                _buildOutlinedIconButton(
                  icon: Icons.map_outlined,
                  tooltip: 'Mappa',
                  onPressed: () => _vaiAMappa(preventivo),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlinedIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.orange),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.orange,
      ),
    );
  }

  void _vaiADettagliPreventivo(Map<String, String> preventivo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreventivoDetailsPage(preventivo: preventivo, orderStatus: '', orderId: '',),
      ),
    );
  }

  void _eliminaPreventivo(Map<String, String> preventivo) {
    setState(() {
      preventiviRichiesti.remove(preventivo);
    });
  }

  void _vaiAMessaggiClienti(Map<String, String> preventivo) {
  }

  void _vaiAMappa(Map<String, String> preventivo) {

  }

  Widget _buildSearchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cerca trasporto...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orange),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
                suffixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              style: TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.calendar_today_outlined, color: Colors.orange),
            onPressed: () => _mostraFiltroDate(context),
            tooltip: 'Filtra Date',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            _richiediOfferte(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
          ),
          child: Text("Richiedi Offerte"),
        ),
        ElevatedButton(
          onPressed: () {
            _vaiARichiesteCancellate(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
          ),
          child: Text("Preventivi Cancellati"),
        ),
      ],
    );
  }

  void _mostraFiltroDate(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
  }

  void _richiediOfferte(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuovaRichiestaSubvezioneScreen(),
      ),
    );
  }

  void _vaiARichiesteCancellate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubvezioniCancellatePage(),
      ),
    );
  }
}
