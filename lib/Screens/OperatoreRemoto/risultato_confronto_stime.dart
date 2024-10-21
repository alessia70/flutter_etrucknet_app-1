import 'package:flutter/material.dart';

// Dialogo per mostrare il risultato del confronto
void RisultatoConfrontoStimeDialog(BuildContext context, List<Map<String, dynamic>> selectedEstimates) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Text(
          'Confronto Stime',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16,
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Data')),
              DataColumn(label: Text('Utente')),
              DataColumn(label: Text('Carico')),
              DataColumn(label: Text('Scarico')),
              DataColumn(label: Text('Stimato')),
            ],
            rows: selectedEstimates.map((estimate) {
              // Visualizza le stime selezionate
              return DataRow(
                cells: [
                  DataCell(Text('${estimate['id']}')),
                  DataCell(Text('${estimate['data']}')),
                  DataCell(Text('${estimate['utente']}')),
                  DataCell(Text('${estimate['carico']}')),
                  DataCell(Text('${estimate['scarico']}')),
                  DataCell(Text('${estimate['stimato']}')),
                ],
              );
            }).toList(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Chiudi',
              style: TextStyle(color: Colors.orange),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// Dialogo per selezionare le stime da confrontare
void showConfrontaStimeDialog(BuildContext context, List<Map<String, dynamic>> stime) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfrontaStimeDialog(stime: stime);
    },
  );
}

class ConfrontaStimeDialog extends StatefulWidget {
  final List<Map<String, dynamic>> stime; // Lista delle stime disponibili

  const ConfrontaStimeDialog({super.key, required this.stime}); // Costruttore con la lista delle stime

  @override
  _ConfrontaStimeDialogState createState() => _ConfrontaStimeDialogState();
}

class _ConfrontaStimeDialogState extends State<ConfrontaStimeDialog> {
  late List<bool> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.generate(widget.stime.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      titlePadding: EdgeInsets.all(16.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.compare_arrows, size: 50, color: Colors.orange),
              SizedBox(width: 10),
              Text(
                'Confronta Stime',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.orange),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Per effettuare il confronto seleziona le stime di interesse:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: ListView.builder(
                itemCount: widget.stime.length,
                itemBuilder: (context, index) {
                  // Mostra ID e stimato come titolo nel checkbox
                  final stima = widget.stime[index];
                  return CheckboxListTile(
                    title: Text('ID: ${stima['id']} - Stimato: ${stima['stimato']}'),
                    subtitle: Text('Carico: ${stima['carico']} - Scarico: ${stima['scarico']}'),
                    value: _selectedItems[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedItems[index] = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.orange,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Chiudi',
            style: TextStyle(color: Colors.orange),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Colore del bottone
            shape: CircleBorder(), // Forma circolare
            padding: EdgeInsets.all(16), // Padding per rendere il bottone più largo
          ),
          onPressed: () {
            // Filtra le stime selezionate e passale al dialogo di risultato
            final stimeSelezionate = widget.stime
                .asMap()
                .entries
                .where((entry) => _selectedItems[entry.key])
                .map((entry) => entry.value) // Passiamo l'intera stima
                .toList();
            
            // Chiudi il dialogo corrente
            Navigator.of(context).pop();

            // Mostra il risultato con le stime selezionate
            RisultatoConfrontoStimeDialog(
              context,
              stimeSelezionate, // Passa l'intera stima
            );
          },
          child: Icon(Icons.check, color: Colors.white),
        ),
      ],
    );
  }
}
