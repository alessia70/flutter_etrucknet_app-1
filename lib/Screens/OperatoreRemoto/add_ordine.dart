import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/order_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class AddOrdineScreen extends StatefulWidget {
  const AddOrdineScreen({super.key});

  @override
  _AddOrdineScreenState createState() => _AddOrdineScreenState();
}

class _AddOrdineScreenState extends State<AddOrdineScreen> {
  String _selectedTransportType = 'Seleziona...';
  final List<String> _transportTypes = [
    'Seleziona...',
    'Trasporto Aereo',
    'Trasporto Marittimo',
    'Trasporto Stradale',
    'Trasporto Ferroviario'
  ];


  String _selectedPackagingType = 'Seleziona...';
  final List<String> _packagingTypes = [
    'Seleziona...',
    'Cartone',
    'Plastica',
    'Legno',
    'Metallo'
  ];

  DateTime? _pickupDate;
  DateTime? _deliveryDate;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

   final TextEditingController _altreInfoController = TextEditingController();

  List<Merce> merceList = [];

   // ignore: unused_field
   final Map<String, dynamic> _orderData = {
    'altreInfo': '',
  };

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

  void _saveOrder() async {
  int orderId = DateTime.now().millisecondsSinceEpoch;
  int tipoCarico = await _getTipoCarico(orderId);

  // ignore: unused_local_variable
  final newOrder = Order(
    id: orderId,
    customerName: 'Customer Name',
    customerContact: 'Customer Contact',
    date: DateTime.now(),
    companyName: 'Company Name',
    loadingDate: _pickupDate?.toIso8601String() ?? '',
    loadingLocation: 'Loading Location',
    loadingProvince: 'Province',
    loadingCountry: 'Country',
    isLoadingMandatory: true,
    isUnloadingMandatory: false,
    unloadingDate: _deliveryDate?.toIso8601String() ?? '',
    unloadingLocation: 'Unloading Location',
    unloadingProvince: 'Province',
    unloadingCountry: 'Country',
    offerAmount: 0.0,
    activeOffers: 0,
    expiredOffers: 0,
    correspondenceCount: 0,
    estimatedBudget: 0.0,
    isCompleted: false,
    isCanceled: false,
  );

  print("Order created with tipoCarico: $tipoCarico");
  Navigator.of(context).pop();
}

Future<int> _getTipoCarico(int idOrdine) async {
  const String apiUrl = 'https://etrucknetapi.azurewebsites.net/v1/GetTipoCarico';

  try {
    final response = await http.get(Uri.parse('$apiUrl/$idOrdine'));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result;
    } else {
      print("Errore durante la chiamata API: ${response.statusCode}");
      return 0;
    }
  } catch (e) {
    print("Errore: $e");
    return 0;
  }
}

  void _cancelOrder() {
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aggiungi Ordine'),
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
                  Icon(Icons.local_shipping, color: Colors.orange, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Seleziona Shipper',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              SizedBox(
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Inserisci nome shipper...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 20),

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
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.storefront, color: Colors.orange, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Ritiro',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Luogo di ritiro...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.home_outlined, color: Colors.orange, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Consegna',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Luogo di consegna...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.date_range, color: Colors.orange, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Data Ritiro',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: _pickupDate == null
                                  ? 'Seleziona data...'
                                  : _pickupDate!.toLocal().toString().split(' ')[0],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              prefixIcon: Icon(Icons.calendar_today, color: Colors.orange),
                            ),
                            onTap: () => _selectPickupDate(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.date_range, color: Colors.orange, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Data Consegna',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: _deliveryDate == null
                                  ? 'Seleziona data...'
                                  : _deliveryDate!.toLocal().toString().split(' ')[0],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              prefixIcon: Icon(Icons.calendar_today, color: Colors.orange),
                            ),
                            onTap: () => _selectDeliveryDate(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20), 

              Divider(
                color: Colors.grey,
                thickness: 1
              ),

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

              Row(
                children: [
                  Icon(Icons.archive, color: Colors.orange, size: 24), 
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

              SizedBox(
                height: 60,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Descrizione della merce...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
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
                  SizedBox(width: 10),

                  IconButton(
                    icon: Icon(Icons.add, color: Colors.orange),
                    onPressed: _addMerce, 
                  ),
                ],
              ),

              SizedBox(height: 20),

              Divider(
                color: Colors.grey,
                thickness: 1, 
              ),

              SizedBox(height: 20),
              Text(
                'Merci Aggiunte:',
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

              SizedBox(height: 20),

              Divider(
                color: Colors.grey,
                thickness: 1, 
              ),

              SizedBox(height: 20),

               Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _altreInfoController,
                    maxLines: 5,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Inserisci ulteriori informazioni...',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _saveOrder,
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            tooltip: 'Salva Ordine',
            child: Icon(Icons.save, size: 30),
          ),
          SizedBox(width: 10), 
          FloatingActionButton(
            onPressed: _cancelOrder,
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
