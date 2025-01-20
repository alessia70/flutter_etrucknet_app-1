import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/allestimento_model.dart';
import 'package:flutter_etrucknet_new/Models/mezzo_allestimento_model.dart';
import 'package:flutter_etrucknet_new/Models/specifiche_model.dart';
import 'package:flutter_etrucknet_new/Models/stima_model.dart';
import 'package:flutter_etrucknet_new/Models/tipoTrasporto_model.dart';
import 'package:flutter_etrucknet_new/Services/mezzo_allestimento_service.dart';
import 'package:flutter_etrucknet_new/Services/tipoAllestimento_services.dart';
import 'package:flutter_etrucknet_new/Services/tipo_trasporto_service.dart';

class ChangeSimulazioneToOrder extends StatefulWidget {
  final List<Item> simulazioneList;
  final String simulazioneTransportType;

  const ChangeSimulazioneToOrder({
    super.key,
    required this.simulazioneList,
    required this.simulazioneTransportType,
  });

  @override
  _ChangeSimulazioneToOrderState createState() =>
      _ChangeSimulazioneToOrderState();
}

class _ChangeSimulazioneToOrderState extends State<ChangeSimulazioneToOrder> {
  late String? _selectedTransportType;
  
  double selectedTemperature = 0.0;
  double selectedTemperatureN = -24.0;

  String selectedMercePericolosa = "";
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  final TipoTrasportoService _service = TipoTrasportoService();
  List<TipoTrasporto> tipiTrasporto = [];
  int? _selectedTrasportoId;

  final TipoMezzoAllestimentoService _serviceMA = TipoMezzoAllestimentoService();
  List<TipoMezzoAllestimento> tipiMezzoAllestimento = [];
  int? _selectedMezzoAllestimentoId;
  
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  final TipoAllestimentoService tipoAllestimentoService = TipoAllestimentoService();

  List<Allestimento> allestimenti = [];
  List<Specifica> specifiche = [];

  List<Item> simulazioneList = [];
  DateTime? _pickupDate;
  DateTime? _deliveryDate;

  Future<void> _selectPickupDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _pickupDate) {
      setState(() {
        _pickupDate = picked;
      });
    }
  }

  Future<void> _selectDeliveryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _deliveryDate) {
      setState(() {
        _deliveryDate = picked;
      });
    }
  }

  Future<void> _fetchTipiTrasporto() async {
    try {
      final fetchedTipiTrasporto = await _service.fetchTipiTrasporto();
      setState(() {
        tipiTrasporto = fetchedTipiTrasporto;
        if (tipiTrasporto.isNotEmpty) {
          _selectedTrasportoId = tipiTrasporto.first.id;
        }
      });
    } catch (e) {
      log('Errore nel recupero dei tipi di trasporto: $e');
    }
  }

  void _fetchTipiMezzoAllestimento() async {
    List<TipoMezzoAllestimento> fetchedTipi = await _serviceMA.fetchTipiMezzoAllestimento();
    setState(() {
      tipiMezzoAllestimento = fetchedTipi;
    });
  }

  Future<void> _loadAllestimenti() async {
    try {
      final allestimentiData = await tipoAllestimentoService.fetchTipoAllestimenti();
      setState(() {
        allestimenti = allestimentiData;
      });
    } catch (e) {
      log("Errore nel recupero degli allestimenti: $e");
    }
  }


  @override
  void initState() {
    super.initState();
    _loadAllestimenti();
    _fetchTipiTrasporto();
    _fetchTipiMezzoAllestimento();
  }

  void _addSimulazione() {
    final newSimulazione = Item(
      packagingType: _selectedTransportType!,
      description: _descriptionController.text,
      quantity: int.tryParse(_quantityController.text) ?? 0,
      weight: double.tryParse(_weightController.text) ?? 0.0,
      length: double.tryParse(_lengthController.text) ?? 0.0,
      width: double.tryParse(_widthController.text) ?? 0.0,
      height: double.tryParse(_heightController.text) ?? 0.0,
      specifications: '',
    );

    setState(() {
      simulazioneList.add(newSimulazione);
      _selectedTransportType = 'Seleziona...';
      _descriptionController.clear();
      _quantityController.clear();
      _weightController.clear();
      _lengthController.clear();
      _widthController.clear();
      _heightController.clear();
    });
  }

  void _removeSimulazione(int index) {
    setState(() {
      simulazioneList.removeAt(index);
    });
  }

  void _saveSimulazione() {
    // Handle save simulazione logic
  }

  void _cancelSimulazione() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    TipoTrasporto tipoTrasporto = TipoTrasporto(id: -1, name: 'Sconosciuto');
    List<int> transportBlockedIds = [4, 10, 24];
    bool isTransportBlocked = transportBlockedIds.contains(tipoTrasporto.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifica Simulazione'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.local_shipping, color: Colors.orange, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Seleziona Tipologia Trasporto',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(_selectedTrasportoId == 2)
                            Row(
                              children: [
                                Icon(Icons.thermostat, color: Colors.orange),
                                SizedBox(width: 8),
                                 Text(
                                  'Temperatura positiva selezionata: ${selectedTemperature.toStringAsFixed(1)} °C',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          if(_selectedTrasportoId == 3)
                            Row(
                              children: [
                                Icon(Icons.thermostat, color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  'Temperatura negativa selezionata: ${selectedTemperatureN.toStringAsFixed(1)} °C',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          if(_selectedTrasportoId == 5)
                            Row(
                              children: [
                                Icon(Icons.warning, color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  'Tipologia di merce pericolosa selezionata: ${selectedMercePericolosa}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )
                        ],
                      ),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.grey, thickness: 1),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.archive, color: Colors.orange, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Allestimenti',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<int>(
                      value: _selectedMezzoAllestimentoId,
                      isExpanded: true,
                      underline: SizedBox(),
                      items: tipiMezzoAllestimento.map((allestimento) {
                        return DropdownMenuItem<int>(
                          value: allestimento.id,
                          child: Text(allestimento.name),
                        );
                      }).toList(),
                      onChanged: isTransportBlocked
                          ? null
                          : (newValue) {
                              setState(() {
                                _selectedMezzoAllestimentoId = newValue!;
                              });
                            },
                    ),
                  ),
                  if (isTransportBlocked)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Per la tipologia di trasporto indicata non è possibile selezionare allestimenti differenti.",
                        style: TextStyle(
                          color: Colors.orange,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Descrizione della simulazione...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.fmd_good_outlined, color: Colors.orange, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Dettagli Merce',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        hintText: 'Quantità (nr)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      decoration: InputDecoration(
                        hintText: 'Peso totale (kg)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _lengthController,
                      decoration: InputDecoration(
                        hintText: 'Lunghezza (cm)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _widthController,
                      decoration: InputDecoration(
                        hintText: 'Larghezza (cm)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _heightController,
                      decoration: InputDecoration(
                        hintText: 'Altezza (cm)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addSimulazione,
                child: Text('Aggiungi Simulazione'),
                style: TextButton.styleFrom(
                      foregroundColor: Colors.orange,
                    ),
              ),
              Divider(color: Colors.grey, thickness: 1),
              SizedBox(height: 20),
              for (int i = 0; i < simulazioneList.length; i++)
                ListTile(
                  title: Text(simulazioneList[i].description),
                  subtitle: Text(
                    'Quantità: ${simulazioneList[i].quantity}, Peso: ${simulazioneList[i].weight} kg',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeSimulazione(i),
                  ),
                ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectPickupDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              _pickupDate == null
                                  ? 'Seleziona data ritiro'
                                  : 'Ritiro: ${_formatDate(_pickupDate!)}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDeliveryDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              _deliveryDate == null
                                  ? 'Seleziona data consegna'
                                  : 'Consegna: ${_formatDate(_deliveryDate!)}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        )
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _saveSimulazione,
                child: Text('Salva'),
                style: ElevatedButton.styleFrom(foregroundColor: Colors.orange),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _cancelSimulazione,
                child: Text('Annulla'),
                style: ElevatedButton.styleFrom(foregroundColor: Colors.orange),
              ),
            ],
          ),
        )

    );
  }
}
