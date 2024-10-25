import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddTruckTDialog extends StatelessWidget {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _linearSpaceController = TextEditingController();
  final TextEditingController _availabilityLocationController = TextEditingController();
  final TextEditingController _availableDateController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  
  bool _isRecurringAvailability = false; // Per lo switch

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Dati Mezzo'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildTypeField(),
            _buildLinearSpaceField(),
            _buildPickupInfoSection(),
            _buildDeliveryInfoSection(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Chiude il popup
          },
          child: Text('Annulla', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            // Aggiungi logica per salvare il camion
            // Puoi usare i valori di _typeController.text, _linearSpaceController.text, etc.
            Navigator.of(context).pop(); // Chiude il popup
          },
          child: Text('Salva'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        ),
      ],
    );
  }

  Widget _buildTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tipo Mezzo'),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _typeController,
                decoration: InputDecoration(
                  hintText: 'Seleziona tipo mezzo',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Logica per aggiungere un altro mezzo
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLinearSpaceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Spazio Lineare disponibile sul pianale (in cm)*:'),
        TextField(
          controller: _linearSpaceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Inserisci spazio lineare'),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPickupInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Informazioni Ritiro', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _availabilityLocationController,
          decoration: InputDecoration(hintText: 'Luogo in cui è disponibile'),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text('Disponibilità Ricorrente'),
            Switch(
              value: _isRecurringAvailability,
              onChanged: (value) {
                _isRecurringAvailability = value;
              },
              activeColor: Colors.orange,
            ),
          ],
        ),
        TextField(
          controller: _availableDateController,
          decoration: InputDecoration(hintText: 'Data in cui è disponibile'),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDeliveryInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Informazioni Consegna', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _destinationController,
          decoration: InputDecoration(hintText: 'Località di destinazione desiderata'),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
