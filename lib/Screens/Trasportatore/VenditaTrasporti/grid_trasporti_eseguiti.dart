import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/VenditaTrasporti/details_trasporto_eseguito.dart';

class TransportiEseguitiGrid extends StatefulWidget {
  final List<dynamic> completedTransports;
  TransportiEseguitiGrid({Key? key, required this.completedTransports}) : super(key: key);

  @override
  _TransportiEseguitiGridState createState() => _TransportiEseguitiGridState();
}

class _TransportiEseguitiGridState extends State<TransportiEseguitiGrid> {
  int _selectedStar = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                'Trasporti Eseguiti',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Ordine')),
                    DataColumn(label: Text('Carico')),
                    DataColumn(label: Text('Scarico')),
                    DataColumn(label: Text('Numero Fattura')),
                    DataColumn(label: Text('Importo Fattura')),
                    DataColumn(label: Text('Data Fattura')),
                    DataColumn(label: Text('Data Scadenza')),
                    DataColumn(label: Text('Azioni')),
                  ],
                  rows: widget.completedTransports.map((transport) {
                    return DataRow(cells: [
                      DataCell(Text(transport['id'] ?? '')),
                      DataCell(Text(transport['localitaRitiro'] ?? '')),
                      DataCell(Text(transport['localitaConsegna'] ?? '')),
                      DataCell(Text(transport['dataRitiro'] ?? '')),
                      DataCell(Text(transport['dataConsegna'] ?? '')),
                      DataCell(Text(transport['tipo'] ?? '')),
                      DataCell(Text(transport['scandenza'] ?? '')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check_circle_outline, color: Colors.orange.shade700),
                            onPressed: () {

                            },
                            tooltip: 'Vedi Conferma',
                          ),
                          IconButton(
                            icon: Icon(Icons.info_outline, color: Colors.orange.shade600),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransportoEseguitioDetailPage(
                                    id: transport['id'] ?? '',
                                    tipoTrasporto: transport['tipo'] ?? '',
                                    distanza: transport['distanza'] ?? '',
                                    tempo: transport['tempo'] ?? '',
                                    localitaRitiro: transport['localitaRitiro'] ?? '',
                                    dataRitiro: transport['dataRitiro'] ?? '',
                                    localitaConsegna: transport['localitaConsegna'] ?? '',
                                    dataConsegna: transport['dataConsegna'] ?? '',
                                    mezziAllestimenti: transport['mezziAllestimenti'] ?? '',
                                    ulterioriSpecifiche: transport['ulterioriSpecifiche'] ?? '',
                                    dettagliMerce: transport['dettagliMerce'] != null
                                        ? List<Map<String, String>>.from(transport['dettagliTrasporto'] as Iterable)
                                        : [],
                                  ),
                                ),
                              );
                            },
                            tooltip: 'Mostra Dettagli',
                          ),
                          IconButton(
                            icon: Icon(Icons.picture_as_pdf, color: Colors.orange.shade500),
                            onPressed: () {
                              _showDDTPopup(context, transport['id'] ?? '');
                            },
                            tooltip: 'Mostra DDT',
                          ),
                          IconButton(
                            icon: Icon(Icons.car_repair, color: Colors.orange.shade400),
                            onPressed: () {
                              _showCommunicaTargaPopup(context, transport['id'] ?? '');
                            },
                            tooltip: 'Comunica Targa',
                          ),
                          IconButton(
                            icon: Icon(Icons.reviews_outlined, color: Colors.orange.shade300),
                            onPressed: () {
                               _showFeedbackPopup(context, transport['id'] ?? '');
                            },
                            tooltip: 'Feedbacks',
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showDDTPopup(BuildContext context, String transportId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('DDT Trasporto N $transportId'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Table(
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey, width: 0.5),
                ),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Committente', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Numero DDT', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Data DDT', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Data Inserimento', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Gestione', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Nome Committente'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('12345'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('01/01/2024'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('02/01/2024'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Gestione X'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Chiudi',
                style: TextStyle(color: Colors.grey),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('Aggiungi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  void _showCommunicaTargaPopup(BuildContext context, String transportId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifica Targa Trasporto N. $transportId'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Targa trattore/motrice: Selezionare la targa o clicca su Carica Automezzi per inserirne una nuova.'),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Targa',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text('Targa rimorchio/semirimorchio: Selezionare la targa o clicca su Carica Rimorchi per inserirne una nuova.'),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Targa',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text('Autista: Selezionare l’autista o clicca su Carica autisti per inserirne uno nuovo.'),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Autista',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Chiudi',
                style: TextStyle(color: Colors.grey),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Salva'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  void _showFeedbackPopup(BuildContext context, String transportId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dettagli Feedback Trasporto N. $transportId'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Clicca sulle stelle a seconda di quanto sei soddisfatto:'),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _selectedStar ? Icons.star : Icons.star_border,
                        color: index < _selectedStar ? Colors.orangeAccent : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_selectedStar == index + 1) {
                            _selectedStar = 0;
                          } else {
                            _selectedStar = index + 1;
                          }
                        });
                      },
                    );
                  }),
                ),
                SizedBox(height: 16),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Ulteriori informazioni',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Chiudi',
                style: TextStyle(color: Colors.grey),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {

                Navigator.of(context).pop(); 
              },
              child: Text('Salva'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
