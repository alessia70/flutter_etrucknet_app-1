import 'package:flutter/material.dart';

class Simulazione {
  String tipoImballo;
  String descrizione;
  String quantita;
  String peso;
  String lunghezza;
  String larghezza;
  String altezza;

  Simulazione({
    required this.tipoImballo,
    required this.descrizione,
    required this.quantita,
    required this.peso,
    required this.lunghezza,
    required this.larghezza,
    required this.altezza,
  });
}

class ChangeSimulazioneToOrder extends StatefulWidget {
  final List<Simulazione> simulazioneList;
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

  List<Simulazione> simulazioneList = [];
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
    _selectedTransportType = widget.simulazioneTransportType;
    simulazioneList = widget.simulazioneList;
    _selectedPackagingType = 'Seleziona...';
  }

  void _addSimulazione() {
    final newSimulazione = Simulazione(
      tipoImballo: _selectedPackagingType,
      descrizione: _descriptionController.text,
      quantita: _quantityController.text,
      peso: _weightController.text,
      lunghezza: _lengthController.text,
      larghezza: _widthController.text,
      altezza: _heightController.text,
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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.local_shipping, color: Colors.blue, size: 24),
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
                  value: _selectedTransportType,
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

              // Simulazione Details (like items, description, packaging, etc)
              Row(
                children: [
                  Icon(Icons.archive, color: Colors.blue, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Tipo Imballo',
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
              ),

              Divider(color: Colors.grey, thickness: 1),
              SizedBox(height: 20),

              // List of added simulazione
              for (int i = 0; i < simulazioneList.length; i++)
                ListTile(
                  title: Text(simulazioneList[i].descrizione),
                  subtitle: Text(
                    'Quantità: ${simulazioneList[i].quantita}, Peso: ${simulazioneList[i].peso} kg',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeSimulazione(i),
                  ),
                ),

              SizedBox(height: 20),

              // Datepickers for delivery/pickup
              Row(
                children: [
                  TextButton(
                    onPressed: () => _selectPickupDate(context),
                    child: Text(
                      _pickupDate == null
                          ? 'Seleziona data ritiro'
                          : 'Ritiro: ${_pickupDate!.toLocal()}',
                    ),
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    onPressed: () => _selectDeliveryDate(context),
                    child: Text(
                      _deliveryDate == null
                          ? 'Seleziona data consegna'
                          : 'Consegna: ${_deliveryDate!.toLocal()}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: _saveSimulazione,
              child: Text('Salva'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _cancelSimulazione,
              child: Text('Annulla'),
            ),
          ],
        ),
      ),
    );
  }
}
