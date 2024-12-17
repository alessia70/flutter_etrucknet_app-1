import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/stima_model.dart';

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
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  final List<String> _transportTypes = [
    'Seleziona...',
    'Trasporto Aereo',
    'Trasporto Marittimo',
    'Trasporto Stradale',
    'Trasporto Ferroviario'
  ];

  late String _selectedPackagingType;
  final List<String> _packagingTypes = [
    'Seleziona...',
    'Cartone',
    'Plastica',
    'Legno',
    'Metallo'
  ];
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    if (_transportTypes.contains(widget.simulazioneTransportType)) {
      _selectedTransportType = widget.simulazioneTransportType;
    } else {
      _selectedTransportType = _transportTypes[0];
    }
    simulazioneList = widget.simulazioneList;
    _selectedPackagingType = _packagingTypes[0];
  }

  void _addSimulazione() {
    final newSimulazione = Item(
      packagingType: _selectedPackagingType,
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
      _selectedPackagingType = 'Seleziona...';
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
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: _transportTypes.contains(_selectedTransportType)
                    ? _selectedTransportType
                    : _transportTypes[0],
                  isExpanded: true,
                  underline: SizedBox(),
                  items: _transportTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTransportType = newValue!;
                    });
                  },
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
                child: DropdownButton<String>(
                  value: _selectedPackagingType,
                  isExpanded: true,
                  underline: SizedBox(),
                  items: _packagingTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPackagingType = newValue!;
                    });
                  },
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
