import 'package:flutter/material.dart';

class Merce {
  String tipoImballo;
  String descrizione;
  String quantita;
  String peso;
  String lunghezza;
  String larghezza;
  String altezza;

  Merce({
    required this.tipoImballo,
    required this.descrizione,
    required this.quantita,
    required this.peso,
    required this.lunghezza,
    required this.larghezza,
    required this.altezza,
  });
}

class ChangeStimaToOrder extends StatefulWidget {
  final List<Merce> stimaMerceList; // Lista della merce già stimata
  final String stimaTransportType;  // Dati stimati per il tipo di trasporto

  const ChangeStimaToOrder({
    super.key,
    required this.stimaMerceList,
    required this.stimaTransportType,
  });

  @override
  _ChangeStimaToOrderState createState() => _ChangeStimaToOrderState();
}

class _ChangeStimaToOrderState extends State<ChangeStimaToOrder> {
  late String _selectedTransportType;
  final List<String> _transportTypes = [
    'Seleziona...',
    'Trasporto Aereo',
    'Trasporto Marittimo',
    'Trasporto Stradale',
    'Trasporto Ferroviario'
  ];

  late String _selectedPackagingType;
  /*final List<String> _packagingTypes = [
    'Seleziona...',
    'Cartone',
    'Plastica',
    'Legno',
    'Metallo'
  ];

  DateTime? _pickupDate;
  DateTime? _deliveryDate;*/

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  //final TextEditingController _altreInfoController = TextEditingController();

  List<Merce> merceList = [];

  @override
  void initState() {
    super.initState();
    _selectedTransportType = _transportTypes.contains(widget.stimaTransportType) 
    ? widget.stimaTransportType 
    : 'Seleziona...';

    merceList = widget.stimaMerceList;
  }

  void _addMerce() {
    final newMerce = Merce(
      tipoImballo: _selectedPackagingType,
      descrizione: _descriptionController.text,
      quantita: _quantityController.text,
      peso: _weightController.text,
      lunghezza: _lengthController.text,
      larghezza: _widthController.text,
      altezza: _heightController.text,
    );

    setState(() {
      merceList.add(newMerce);
      _selectedPackagingType = 'Seleziona...';
      _descriptionController.clear();
      _quantityController.clear();
      _weightController.clear();
      _lengthController.clear();
      _widthController.clear();
      _heightController.clear();
    });
  }

  void _removeMerce(int index) {
    setState(() {
      merceList.removeAt(index);
    });
  }

  void _saveStimaasOrder() {
    // Logica per salvare l'ordine aggiornato
  }

  void _cancelStima() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifica Ordine'),
        backgroundColor: Colors.orange,
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
                  Icon(Icons.directions_car, color: Colors.orange, size: 24),
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
              Text(
                'Dettagli Merce',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 10),
              
              // Sezione per aggiungere nuova merce
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Descrizione della merce...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 10),
              
              SizedBox(height: 20),
              Text(
                'Merci Aggiunte dalla Stima:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 10),
              ...merceList.map((merce) {
                final index = merceList.indexOf(merce);
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(merce.descrizione),
                    subtitle: Text(
                      'Tipo Imballo: ${merce.tipoImballo}, Quantità: ${merce.quantita}, Peso: ${merce.peso}, Dimensioni: ${merce.lunghezza} x ${merce.larghezza} x ${merce.altezza} cm',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeMerce(index),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _saveStimaasOrder,
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            tooltip: 'Salva Ordine',
            child: Icon(Icons.save, size: 30),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _cancelStima,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            tooltip: 'Annulla',
            child: Icon(Icons.close, size: 30),
          ),
        ],
      ),
    );
  }
}
