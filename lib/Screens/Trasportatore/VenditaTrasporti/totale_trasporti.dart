import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/transport_model.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/grid_proposte_trasporti.dart';

class TotaleTrasportiScreen extends StatefulWidget {
  @override
  _TotaleTrasportiScreenState createState() => _TotaleTrasportiScreenState();
}

class _TotaleTrasportiScreenState extends State<TotaleTrasportiScreen> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedStatoTrasporto = 'Tutti';
  String selectedAllestimento = 'Tutti';
  TextEditingController luogoCaricoController = TextEditingController();
  TextEditingController luogoScaricoController = TextEditingController();
  TextEditingController numeroPrezzoController = TextEditingController();

   List<Transport> transports = [];

  @override
  void dispose() {
    luogoCaricoController.dispose();
    luogoScaricoController.dispose();
    numeroPrezzoController.dispose();
    super.dispose();
  }

  void _mostraFiltroDate() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Trasporti Proposti'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Cerca Trasporto',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedStatoTrasporto,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatoTrasporto = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Stato',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    ),
                    isDense: true,
                    isExpanded: true,
                    items: <String>[
                      'Tutti',
                      'Da Quotare',
                      'In Quotazione',
                      'Quotazione Scaduta'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.orange),
                  onPressed: _mostraFiltroDate,
                  tooltip: 'Filtra Date',
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: selectedAllestimento,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAllestimento = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Tipo Allestimento',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    ),
                    items: <String>[
                      'Tutti',
                      'Standard',
                      'Furgone isotermico'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: numeroPrezzoController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Prezzo',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    ),
                  ),
                ),
                Container(
                  width: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_drop_up),
                        constraints: BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            int currentValue = int.tryParse(numeroPrezzoController.text) ?? 0;
                            numeroPrezzoController.text = (currentValue + 1).toString();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down),
                        constraints: BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            int currentValue = int.tryParse(numeroPrezzoController.text) ?? 0;
                            numeroPrezzoController.text = (currentValue > 0 ? currentValue - 1 : 0).toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: luogoCaricoController,
                    decoration: InputDecoration(
                      labelText: 'Luogo Carico',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: luogoScaricoController,
                    decoration: InputDecoration(
                      labelText: 'Luogo Scarico',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: TrasportiGrid(
              ),
            ),
          ],
        ),
      ),
    );
  }
}
