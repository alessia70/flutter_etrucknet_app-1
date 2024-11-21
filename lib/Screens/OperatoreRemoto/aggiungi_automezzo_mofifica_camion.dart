import 'package:flutter/material.dart';

class AggiungiAutomezzoDialog extends StatefulWidget {
  final Function(String, String, String) onSave;

  const AggiungiAutomezzoDialog({required this.onSave, Key? key}) : super(key: key);

  @override
  _AggiungiAutomezzoDialogState createState() => _AggiungiAutomezzoDialogState();
}

class _AggiungiAutomezzoDialogState extends State<AggiungiAutomezzoDialog> {
  String? selectedTipoAutomezzo;
  String? selectedTipoAllestimento;
  String? selectedSpecifiche;

  final List<String> tipiAutomezzo = ['Camion', 'Furgone', 'Tir'];
  final Map<String, List<String>> allestimenti = {
    'Camion': ['Frigo', 'Cassonato', 'Rimorchio'],
    'Furgone': ['Chiusi', 'Aperto'],
    'Tir': ['Rimorchio', 'Telonato']
  };
  final Map<String, List<String>> specifiche = {
    'Frigo': ['Congelato', 'Refrigerato'],
    'Cassonato': ['Standard', 'Extra-Lungo'],
    'Rimorchio': ['Leggero', 'Pesante'],
    'Chiusi': ['Con sponde', 'Senza sponde'],
    'Aperto': ['Telonato', 'Non Telonato'],
    'Telonato': ['Alto', 'Basso'],
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.local_shipping, color: Colors.orange),
          SizedBox(width: 10),
          Text("Aggiungi Automezzo"),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleziona Tipo Automezzo:',
              style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedTipoAutomezzo,
              hint: const Text("Seleziona tipo automezzo"),
              items: tipiAutomezzo.map((tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedTipoAutomezzo = newValue;
                  selectedTipoAllestimento = null; 
                });
              },
            ),
            const SizedBox(height: 20),

            if (selectedTipoAutomezzo != null) ...[
              const Text(
                'Seleziona Tipo Allestimento:',
                style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedTipoAllestimento,
                hint: const Text("Seleziona tipo allestimento"),
                items: allestimenti[selectedTipoAutomezzo!]!.map((allestimento) {
                  return DropdownMenuItem<String>(
                    value: allestimento,
                    child: Text(allestimento),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedTipoAllestimento = newValue;
                    selectedSpecifiche = null;
                  });
                },
              ),
            ],
            const SizedBox(height: 20),
            if (selectedTipoAllestimento != null) ...[
              const Text(
                'Seleziona Specifiche:',
                style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedSpecifiche,
                hint: const Text("Seleziona specifiche"),
                items: specifiche[selectedTipoAllestimento!]!.map((specifica) {
                  return DropdownMenuItem<String>(
                    value: specifica,
                    child: Text(specifica),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedSpecifiche = newValue;
                  });
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (selectedTipoAutomezzo != null &&
                selectedTipoAllestimento != null &&
                selectedSpecifiche != null) {
              widget.onSave(selectedTipoAutomezzo!, selectedTipoAllestimento!, selectedSpecifiche!);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Seleziona tutte le opzioni.')),
              );
            }
          },
          child: const Text("Salva"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white)
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Annulla", style: TextStyle(color: Colors.orange),),
        ),
      ],
    );
  }
}
