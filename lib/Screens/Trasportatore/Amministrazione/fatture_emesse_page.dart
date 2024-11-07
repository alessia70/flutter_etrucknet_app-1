import 'package:flutter/material.dart';

class FattureEmessePage extends StatefulWidget {
  @override
  _FattureEmessePageState createState() => _FattureEmessePageState();
}

class _FattureEmessePageState extends State<FattureEmessePage> {
  String dropdownValue = 'Tutte';
  final List<String> statoEmesseOptions = ['Tutte', 'Scadute', 'Non Scadute', 'Acconto', 'Saldate'];

  // Esempio di dati per le fatture emesse
  final List<Map<String, String>> fattureEmesse = [
    {'id': '1', 'cliente': 'Cliente A', 'data': '01/11/2024', 'importo': '1000 €', 'stato': 'Saldata'},
    {'id': '2', 'cliente': 'Cliente B', 'data': '02/11/2024', 'importo': '1500 €', 'stato': 'Scaduta'},
    // Aggiungi altre fatture emesse qui
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fatture Emesse'),
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
            // Card con le fatture
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
                        'Fatture Emesse',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 16),
                      // DataTable per le fatture
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Fattura')),
                            DataColumn(label: Text('Cliente')),
                            DataColumn(label: Text('Data')),
                            DataColumn(label: Text('Importo')),
                            DataColumn(label: Text('Stato')),
                          ],
                          rows: fattureEmesse.map((fattura) {
                            return DataRow(cells: [
                              DataCell(Text(fattura['id'] ?? '')),
                              DataCell(Text(fattura['cliente'] ?? '')),
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
                  hintText: 'Cerca ricevuta...',
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
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: dropdownValue,
                items: statoEmesseOptions.map((String value) {
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
