import 'package:flutter/material.dart';

void RisultatoConfrontoSimulazioniDialog(BuildContext context, List<Map<String, dynamic>> selectedEstimates) {
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
              return DataRow(
                cells: [
                  DataCell(Text('${estimate['id'] ?? 'N/A'}')),
                  DataCell(Text('${estimate['data'] ?? 'N/A'}')),
                  DataCell(Text('${estimate['utente'] ?? 'N/A'}')),
                  DataCell(Text('${estimate['carico'] ?? 'N/A'}')),
                  DataCell(Text('${estimate['scarico'] ?? 'N/A'}')),
                  DataCell(Text('${estimate['stimato'] ?? 'N/A'}')),
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

void showConfrontaStimeDialog(BuildContext context, List<Map<String, dynamic>> stime) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfrontaSimulazioniDialog(stime: stime);
    },
  );
}

class ConfrontaSimulazioniDialog extends StatefulWidget {
  final List<Map<String, dynamic>> stime;

  const ConfrontaSimulazioniDialog({super.key, required this.stime}); 

  @override
  _ConfrontaSimulazioniDialogState createState() => _ConfrontaSimulazioniDialogState();
}

class _ConfrontaSimulazioniDialogState extends State<ConfrontaSimulazioniDialog> {
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
                  return CheckboxListTile(
                    title: Text(widget.stime[index]['stimato']),
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
            backgroundColor: Colors.orange, 
          ),
          onPressed: () {
            final stimeSelezionate = widget.stime
                .asMap()
                .entries
                .where((entry) => _selectedItems[entry.key]) 
                .map((entry) => entry.value) 
                .toList();

            RisultatoConfrontoSimulazioniDialog(
              context, 
              stimeSelezionate, 
            );
          },
          child: Text(
            'Conferma',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
