import 'package:flutter/material.dart';

class FattureRicevutePage extends StatefulWidget {
  @override
  _FattureRicevutePageState createState() => _FattureRicevutePageState();
}

class _FattureRicevutePageState extends State<FattureRicevutePage> {
  String dropdownValue = 'Tutte';
  final List<String> statoRicevuteOptions = ['Tutte', 'Scadute', 'Non Scadute', 'Acconto', 'Saldate'];

  // Esempio di dati per le fatture ricevute
  final List<Map<String, String>> fattureRicevute = [
    {'id': '1', 'fornitore': 'Fornitore A', 'data': '01/11/2024', 'importo': '1200 €', 'stato': 'Saldata'},
    {'id': '2', 'fornitore': 'Fornitore B', 'data': '03/11/2024', 'importo': '800 €', 'stato': 'Scaduta'},
    // Aggiungi altre fatture ricevute qui
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fatture Ricevute'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchAndFilterBox(context),
            SizedBox(height: 16),
            // Card con le fatture ricevute
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fatture Ricevute',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 16),
                      // DataTable per le fatture ricevute
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Fattura')),
                            DataColumn(label: Text('Fornitore')),
                            DataColumn(label: Text('Data')),
                            DataColumn(label: Text('Importo')),
                            DataColumn(label: Text('Stato')),
                          ],
                          rows: fattureRicevute.map((fattura) {
                            return DataRow(cells: [
                              DataCell(Text(fattura['id'] ?? '')),
                              DataCell(Text(fattura['fornitore'] ?? '')),
                              DataCell(Text(fattura['data'] ?? '')),
                              DataCell(Text(fattura['importo'] ?? '')),
                              DataCell(Text(fattura['stato'] ?? '')),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBox(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cerca fattura...',
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
          ],
        ),
        SizedBox(height: 8),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: dropdownValue,
                items: statoRicevuteOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
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
}
