import 'package:flutter/material.dart';

class EditCamionDialog extends StatefulWidget {
  final Map<String, String> truck;
  final Function(Map<String, String>) onSave;

  const EditCamionDialog({Key? key, required this.truck, required this.onSave}) : super(key: key);

  @override
  _EditCamionDialogState createState() => _EditCamionDialogState();
}

class _EditCamionDialogState extends State<EditCamionDialog> {
  final TextEditingController transportCompanyController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController vehicleDataController = TextEditingController();
  final TextEditingController availableSpaceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController loadingDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    transportCompanyController.text = widget.truck['transportCompany']!;
    contactController.text = widget.truck['contact']!;
    vehicleDataController.text = widget.truck['vehicleData']!;
    availableSpaceController.text = widget.truck['availableSpace']!;
    locationController.text = widget.truck['location']!;
    destinationController.text = widget.truck['destination']!;
    loadingDateController.text = widget.truck['loadingDate']!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifica Camion'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: transportCompanyController,
              decoration: const InputDecoration(labelText: 'Trasportatore'),
            ),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'Contatto'),
            ),
            TextField(
              controller: vehicleDataController,
              decoration: const InputDecoration(labelText: 'Dati Veicolo'),
            ),
            TextField(
              controller: availableSpaceController,
              decoration: const InputDecoration(labelText: 'Spazio Disponibile'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Posizione'),
            ),
            TextField(
              controller: destinationController,
              decoration: const InputDecoration(labelText: 'Destinazione'),
            ),
            TextField(
              controller: loadingDateController,
              decoration: const InputDecoration(labelText: 'Data Carico'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Passa i dati aggiornati
            widget.onSave({
              'id': widget.truck['id']!,
              'transportCompany': transportCompanyController.text,
              'contact': contactController.text,
              'vehicleData': vehicleDataController.text,
              'availableSpace': availableSpaceController.text,
              'location': locationController.text,
              'destination': destinationController.text,
              'loadingDate': loadingDateController.text,
            });
            Navigator.of(context).pop(); // Chiudi solo il dialogo
          },
          child: const Text("Salva"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Annulla", style: TextStyle(color: Colors.orange)),
        ),
      ],
    );
  }
}
