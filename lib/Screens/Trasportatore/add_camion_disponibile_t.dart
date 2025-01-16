import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/camion_model.dart';

class AddCamionDialog extends StatefulWidget {
  final Camion? existingCamion;

  const AddCamionDialog({super.key, this.existingCamion});

  @override
  _AddCamionDialogState createState() => _AddCamionDialogState();
}

class _AddCamionDialogState extends State<AddCamionDialog> {
  final tipoMezzoController = TextEditingController();
  final spazioDisponibileController = TextEditingController();
  final localitaCaricoController = TextEditingController();
  final localitaScaricoController = TextEditingController();
  DateTime? dataRitiro;
  bool isRecurring = false;
  Map<String, bool> selectedDays = {
    "Lunedì": false,
    "Martedì": false,
    "Mercoledì": false,
    "Giovedì": false,
    "Venerdì": false,
    "Sabato": false,
    "Domenica": false,
  };

  @override
  void initState() {
    super.initState();
    if (widget.existingCamion != null) {
      tipoMezzoController.text = widget.existingCamion!.tipoMezzo;
      spazioDisponibileController.text = widget.existingCamion!.spazioDisponibile.toString();
      localitaCaricoController.text = widget.existingCamion!.localitaCarico!;
      localitaScaricoController.text = widget.existingCamion!.localitaScarico!;
      dataRitiro = widget.existingCamion!.dataRitiro;
      isRecurring = widget.existingCamion!.isRecurring;
      selectedDays = widget.existingCamion!.giorniDisponibili ?? selectedDays;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingCamion == null ? 'Aggiungi Camion Disponibile' : 'Modifica Camion Disponibile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tipoMezzoController,
              decoration: const InputDecoration(labelText: 'Tipo Automezzo*'),
            ),
            TextField(
              controller: spazioDisponibileController,
              decoration: const InputDecoration(labelText: 'Spazio Lineare disponibile (in cm)*'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: localitaCaricoController,
              decoration: const InputDecoration(labelText: 'Luogo in cui è disponibile*'),
            ),
            const SizedBox(height: 16),
            _buildDateField(context, 'Data Ritiro', dataRitiro, (picked) => setState(() => dataRitiro = picked)),
            TextField(
              controller: localitaScaricoController,
              decoration: const InputDecoration(labelText: 'Località di destinazione desiderata*'),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Disponibilità Settimanale Ricorrente'),
              value: isRecurring,
              onChanged: (value) {
                setState(() {
                  isRecurring = value;
                });
              },
            ),
            if (isRecurring) _buildDaysOfWeekSelector(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (tipoMezzoController.text.isNotEmpty &&
                spazioDisponibileController.text.isNotEmpty &&
                localitaCaricoController.text.isNotEmpty &&
                dataRitiro != null &&
                localitaScaricoController.text.isNotEmpty) {
              final newCamion = Camion(
                id: null,
                tipoMezzo: tipoMezzoController.text,
                spazioDisponibile: spazioDisponibileController.text,
                 localitaCarico: localitaCaricoController.text.isEmpty ? null : localitaCaricoController.text,
                dataRitiro: dataRitiro!,
                localitaScarico: localitaScaricoController.text,
                isRecurring: isRecurring,
                giorniDisponibili: isRecurring ? selectedDays : null,
              );
              Navigator.of(context).pop(newCamion);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compila tutti i campi obbligatori')),
              );
            }
          },
          child: Text(widget.existingCamion == null ? 'Aggiungi' : 'Salva', style: const TextStyle(color: Colors.orange)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, String label, DateTime? date, ValueChanged<DateTime?> onDatePicked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        TextButton(
          onPressed: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            onDatePicked(pickedDate);
          },
          child: Text(date != null ? '${date.day}/${date.month}/${date.year}' : 'Seleziona Data'),
        ),
      ],
    );
  }

  Widget _buildDaysOfWeekSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Giorni di Disponibilità:'),
        ...selectedDays.keys.map((day) {
          return CheckboxListTile(
            title: Text(day),
            value: selectedDays[day],
            onChanged: (value) {
              setState(() {
                selectedDays[day] = value ?? false;
              });
            },
          );
        }),
      ],
    );
  }
}
