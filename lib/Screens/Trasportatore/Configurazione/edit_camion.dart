import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_etrucknet_new/Models/camion_model.dart';

class EditCamionDialog extends StatefulWidget {
  final Camion camion;

  const EditCamionDialog({required this.camion});

  @override
  _EditCamionDialogState createState() => _EditCamionDialogState();
}

class _EditCamionDialogState extends State<EditCamionDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controller per i campi
  late TextEditingController tipoMezzoController;
  late TextEditingController spazioController;
  late TextEditingController luogoRitiroController;
  late TextEditingController luogoConsegnaController;
  DateTime? dataDisponibile;

  @override
  void initState() {
    super.initState();
    tipoMezzoController = TextEditingController(text: widget.camion.tipoMezzo);
    spazioController = TextEditingController(
        text: widget.camion.spazioDisponibile.toString() ?? '');
    luogoRitiroController =
        TextEditingController(text: widget.camion.localitaCarico);
    luogoConsegnaController =
        TextEditingController(text: widget.camion.localitaScarico);
    dataDisponibile = widget.camion.dataRitiro;
  }

  @override
  void dispose() {
    tipoMezzoController.dispose();
    spazioController.dispose();
    luogoRitiroController.dispose();
    luogoConsegnaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dataDisponibile ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != dataDisponibile) {
      setState(() {
        dataDisponibile = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifica Camion Disponibile'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dati Mezzo', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: tipoMezzoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo Automezzo*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obbligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: spazioController,
                decoration: const InputDecoration(
                  labelText: 'Spazio Lineare disponibile (cm)*',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obbligatorio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Inserisci un numero valido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Informazioni Ritiro', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: luogoRitiroController,
                decoration: const InputDecoration(
                  labelText: 'Luogo in cui è disponibile*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obbligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                  child: Text(
                    dataDisponibile != null
                        ? 'Data: ${DateFormat('dd/MM/yyyy').format(dataDisponibile!)}'
                        : 'Seleziona Data*',
                    style: TextStyle(
                      color: dataDisponibile != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Informazioni Consegna', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: luogoConsegnaController,
                decoration: const InputDecoration(
                  labelText: 'Località di destinazione desiderata*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obbligatorio';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Chiudi'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Salva'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final updatedCamion = Camion(
                id: widget.camion.id,
                tipoMezzo: tipoMezzoController.text,
                spazioDisponibile: spazioController.text,
                localitaCarico: luogoRitiroController.text,
                localitaScarico: luogoConsegnaController.text,
                dataRitiro: dataDisponibile ?? DateTime.now(),
              );
              try {
                await _updateCamion(updatedCamion);
                Navigator.of(context).pop(true);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Errore durante il salvataggio')),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Future<void> _updateCamion(Camion camion) async {
    final url = Uri.parse(
        'https://etrucknetapi.azurewebsites.net/v1/CamionDisponibili/${camion.id}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer your_token_here',
        'Content-Type': 'application/json',
      },
      body: json.encode(camion.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Errore durante l\'aggiornamento: ${response.statusCode}');
    }
  }
}
