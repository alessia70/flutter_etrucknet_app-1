import 'package:flutter/material.dart';

class TrattePage extends StatefulWidget {
  @override
  _TrattePageState createState() => _TrattePageState();
}

class _TrattePageState extends State<TrattePage> {
  List<Map<String, String>> tratte = []; // List to store the routes

  // Variables for the dialog
  String partenza = '';
  String direzione = 'Andata'; // Initial value
  String arrivo = '';
  String automezzo = 'Camion 1'; // Initial value
  String servizio = 'Servizio A'; // Initial value
  String mercePericolosa = 'Gas'; // Initial value
  bool adrMercePericolosa = false;
  bool isMercePericolosaSelected = false; // Track if Dangerous Goods is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tratte'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(context),
            SizedBox(height: 16),
            _buildTratteTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Cerca tratte',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.add_box_outlined, color: Colors.orange),
          onPressed: () {
            _showAddTrattaDialog(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.filter_list, color: Colors.grey),
          onPressed: () {
            // Logic for filtering routes
          },
        ),
      ],
    );
  }

  Widget _buildTratteTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Partenze')),
                  DataColumn(label: Text('Direzione')),
                  DataColumn(label: Text('Arrivi')),
                  DataColumn(label: Text('Automezzi')),
                  DataColumn(label: Text('Servizi')),
                  DataColumn(label: Text('Azioni')),
                ],
                rows: tratte.map((tratta) {
                  return _buildDataRow(
                    tratta['partenza']!,
                    tratta['direzione']!,
                    tratta['arrivo']!,
                    tratta['automezzo']!,
                    tratta['servizio']!,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String partenza, String direzione, String arrivo, String automezzo, String servizio) {
    return DataRow(cells: [
      DataCell(Text(partenza)),
      DataCell(Text(direzione)),
      DataCell(Text(arrivo)),
      DataCell(Text(automezzo)),
      DataCell(Text(servizio)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.orange),
            onPressed: () {
              // Logic to edit the route
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.grey),
            onPressed: () {
              // Logic to delete the route
              setState(() {
                tratte.removeWhere((tratta) => tratta['partenza'] == partenza && tratta['arrivo'] == arrivo);
              });
            },
          ),
        ],
      )),
    ]);
  }

  void _showAddTrattaDialog(BuildContext context) {
    String dialogPartenza = partenza;
    String dialogDirezione = direzione; // Copy current state
    String dialogArrivo = arrivo;
    String dialogAutomezzo = automezzo; // Copy current state
    String dialogServizio = servizio; // Copy current state
    String dialogMercePericolosa = mercePericolosa; // Copy current state
    bool dialogAdrMercePericolosa = adrMercePericolosa; // Copy current state

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.add, color: Colors.orange),
              SizedBox(width: 8),
              Text('Aggiungi Tratte più Frequenti'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inserisci dati puntuali:\n'
                  'Scegli alternativamente provincia, regione o la nazione di partenza e di arrivo, '
                  'i tipi di camion che utilizzi ed i servizi che offri. '
                  'Puoi inserire quante tratte vuoi in modo da descrivere ognuna dettagliatamente.\n'
                  'Attenzione: le proposte di carico le riceverai in funzione ai dati da te inseriti.',
                ),
                SizedBox(height: 16),

                // Title for Departure
                Text('Partenza', style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) => dialogPartenza = value,
                ),
                SizedBox(height: 16),

                // Title for Direction
                Text('Direzione', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: dialogDirezione,
                  isExpanded: true, // Make dropdown full width
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        dialogDirezione = newValue;
                        direzione = newValue; // Update the default variable immediately
                      });
                    }
                  },
                  items: <String>['Andata', 'Ritorno', 'Andata/Ritorno']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),

                // Title for Arrival
                Text('Arrivo', style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) => dialogArrivo = value,
                ),
                SizedBox(height: 16),

                // Title for Vehicle
                Text('Automezzo', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: dialogAutomezzo,
                  isExpanded: true, // Make dropdown full width
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        dialogAutomezzo = newValue;
                        automezzo = newValue; // Update the default variable immediately
                      });
                    }
                  },
                  items: <String>[
                    'Camion 1',
                    'Camion 2',
                    'Camion 3',
                    'Furgone',
                    'Auto',
                    'Camion frigorifero'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),

                // Title for Service
                Text('Servizi', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: dialogServizio,
                  isExpanded: true, // Make dropdown full width
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        dialogServizio = newValue;
                        servizio = newValue; // Update the default variable immediately
                        isMercePericolosaSelected = newValue == 'Merce Pericolosa'; // Check if selected
                      });
                    }
                  },
                  items: <String>[
                    'Servizio A',
                    'Servizio B',
                    'Servizio C',
                    'Merce Pericolosa' // Include option for Dangerous Goods
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),

                // Dangerous Goods Dropdown
                if (isMercePericolosaSelected) ...[
                  Text('Tipologia Merce Pericolosa', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: dialogMercePericolosa,
                    isExpanded: true, // Make dropdown full width
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          dialogMercePericolosa = newValue;
                          mercePericolosa = newValue; // Update the default variable immediately
                        });
                      }
                    },
                    items: <String>[
                      'Gas',
                      'Liquidi infiammabili',
                      'Polveri',
                      'Materiali corrosivi',
                      'Sostanze tossiche',
                      'Materiali radioattivi',
                      'Sostanze pericolose per l’ambiente'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                ],

                // ADR Dangerous Goods Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: dialogAdrMercePericolosa,
                      onChanged: (bool? value) {
                        setState(() {
                          dialogAdrMercePericolosa = value ?? false;
                          adrMercePericolosa = value ?? false; // Update the default variable immediately
                        });
                      },
                    ),
                    Text('ADR Merce Pericolosa'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tratte.add({
                    'partenza': dialogPartenza,
                    'direzione': dialogDirezione,
                    'arrivo': dialogArrivo,
                    'automezzo': dialogAutomezzo,
                    'servizio': dialogServizio,
                    'mercePericolosa': isMercePericolosaSelected ? dialogMercePericolosa : '',
                  });
                });
                _showConfirmationDialog(context); // Show confirmation dialog
                Navigator.pop(context);
              },
              child: Text('Salva'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tratta Aggiunta'),
          content: Text('La tratta è stata aggiunta con successo!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
