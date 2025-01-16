import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_etrucknet_new/Models/allestimento_model.dart';
import 'package:flutter_etrucknet_new/Models/mezzo_allestimento_model.dart';
import 'package:flutter_etrucknet_new/Models/order_model.dart';
import 'package:flutter_etrucknet_new/Models/tipoTrasporto_model.dart';
import 'package:flutter_etrucknet_new/Models/tipo_mezzo_specifiche_model.dart';
import 'package:flutter_etrucknet_new/Services/mezzo_allestimento_service.dart';
import 'package:flutter_etrucknet_new/Services/tipoAllestimento_services.dart';
import 'package:flutter_etrucknet_new/Services/tipo_mezzo_specifiche.dart';
import 'package:flutter_etrucknet_new/Services/tipo_trasporto_service.dart';
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
  final TipoTrasportoService _service = TipoTrasportoService();
  List<TipoTrasporto> tipiTrasporto = [];
  int? _selectedTrasportoId;

  final TipoMezzoAllestimentoService _serviceMA = TipoMezzoAllestimentoService();
  List<TipoMezzoAllestimento> tipiMezzoAllestimento = [];
  int? _selectedMezzoAllestimentoId;

  List<TipoMezzoSpecifiche> tipiMezzoSpecifiche = [];

  String _selectedPackagingType = 'Seleziona...';

  DateTime? _pickupDate;
  DateTime? _deliveryDate;

  double selectedTemperature = 0.0;
  double selectedTemperatureN = -24.0;

  String selectedMercePericolosa = "";

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TipoAllestimentoService tipoAllestimentoService = TipoAllestimentoService();
  final TipoMezzoSpecificheService tipoSpecificheService = TipoMezzoSpecificheService();

  List<Merce> merceList = [];
  List<Allestimento> allestimenti = [];
  List<TipoMezzoSpecifiche> specifiche = [];
  TipoMezzoSpecifiche? selectedSpecifica;

  String? _selectedImballo;
  /*final OrderLogic _orderLogic = OrderLogic();
  String? _selectedTransportType;
  double? _selectedTemperature;*/
  
  bool _caricataLateralmente = false;
  bool _pagataContrassegno = false;
  bool _problemiViabilita = false;

  @override
  void initState() {
    super.initState();
    _loadAllestimenti();
    _fetchTipiTrasporto();
    _fetchTipiMezzoAllestimento();
    _loadSpecifiche();
  }

  void _fetchTipiMezzoAllestimento() async {
    List<TipoMezzoAllestimento> fetchedTipi = await _serviceMA.fetchTipiMezzoAllestimento();
    setState(() {
      tipiMezzoAllestimento = fetchedTipi;
    });
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

  Future<void> _loadSpecifiche() async {
    try {
      final specificheData = await tipoSpecificheService.fetchTipiMezzoSpecifiche();
      setState(() {
        specifiche = specificheData;
      });
    } catch (e) {
      log("Errore nel recupero degli allestimenti: $e");
    }
  }
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
      lastDate: DateTime(2050),
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
      vehicleType: null,
      additionalSpecs: null,
      isSideLoadingRequired: false,
      isCashOnDelivery: false,
      hasRoadAccessibilityIssues: false,
      packagingType: _selectedPackagingType,
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      quantity: int.tryParse(_quantityController.text),
      totalWeight: double.tryParse(_weightController.text),
      length: double.tryParse(_lengthController.text),
      width: double.tryParse(_widthController.text),
      height: double.tryParse(_heightController.text),
    );
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
        log("Errore durante la chiamata API: ${response.statusCode}");
        return 0;
      }
    } catch (e) {
      log("Errore: $e");
      return 0;
    }
  }

  void _cancelOrder() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    TipoTrasporto tipoTrasporto = TipoTrasporto(id: -1, name: 'Sconosciuto');
    List<int> transportBlockedIds = [4, 10, 24];
    bool isTransportBlocked = transportBlockedIds.contains(tipoTrasporto.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('Aggiungi Ordine'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            SingleChildScrollView(
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
                    child: DropdownButton<int>(
                      value: _selectedTrasportoId,
                      isExpanded: true,
                      items: tipiTrasporto.map((trasporto) {
                        return DropdownMenuItem<int>(
                          value: trasporto.id,
                          child: Text(trasporto.name),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedTrasportoId = newValue;
                        });
                        TipoTrasporto? selectedTrasporto = tipiTrasporto.firstWhere(
                          (trasporto) => trasporto.id == newValue,
                          orElse: () => TipoTrasporto(id: -1, name: 'Trasporto sconosciuto'),
                        );
                        TipoTrasportoService().showTipoTrasportoDialog(
                          context,
                          selectedTrasporto,
                          selectedTemperature,
                          selectedTemperatureN,
                          (double newTemperature) {
                            setState(() {
                              selectedTemperature = newTemperature;
                            });
                          },
                          (double newTemperatureN) {
                            setState(() {
                              selectedTemperatureN = newTemperatureN;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_selectedTrasportoId == 2 || _selectedTrasportoId == 3 || _selectedTrasportoId == 5)
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
                  Divider(color: Colors.grey, thickness: 1),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.archive, color: Colors.orange, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Tipo Mezzo/Allestimenti',
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
                    Divider(color: Colors.grey, thickness: 1),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.archive, color: Colors.orange, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Ulteriori Specifiche',
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
                      child: DropdownButton<TipoMezzoSpecifiche>(
                        value: selectedSpecifica,
                        isExpanded: true,
                        underline: SizedBox(),
                        hint: Text('Seleziona una specifica'),
                        items: specifiche.map((TipoMezzoSpecifiche specifica) {
                          return DropdownMenuItem<TipoMezzoSpecifiche>(
                            value: specifica,
                            child: Text(specifica.descrizione),
                          );
                        }).toList(),
                        onChanged: (TipoMezzoSpecifiche? nuovaSpecifica) {
                          setState(() {
                            selectedSpecifica = nuovaSpecifica;
                          });
                        },
                        icon: Icon(Icons.arrow_drop_down),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSwitchOption('Merce caricata lateralmente', _caricataLateralmente, (value) {
                          setState(() {
                            _caricataLateralmente = value;
                          });
                        }),
                        _buildSwitchOption('Merce pagata in contrassegno', _pagataContrassegno, (value) {
                          setState(() {
                            _pagataContrassegno = value;
                          });
                        }),
                        _buildSwitchOption('Problemi di viabilità', _problemiViabilita, (value) {
                          setState(() {
                            _problemiViabilita = value;
                          });
                        }),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(color: Colors.grey, thickness: 1),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.shopping_basket, color: Colors.orange, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Dettagli Merce',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tipo Imballo*',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                height: 40,
                                child: DropdownButton<String>(
                                  value: _selectedImballo,
                                  hint: Text('Seleziona tipo di imballo'),
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  isDense: true,
                                  items: <String>[
                                    'Bancali',
                                    'Containers',
                                    'Altro',
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    _selectedImballo = newValue;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Descrizione*',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                height: 40,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Inserisci descrizione...',
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
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quantità (nr)*',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                height: 40,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Inserisci quantità...',
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
                    SizedBox(height: 10),
                    Row(
                    children: [
                      // Quantità
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantità (nr)*',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Inserisci quantità...',
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
                      SizedBox(width: 10),
                      // Peso Totale
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Peso Totale (kg)*',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Inserisci peso...',
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      // Lunghezza
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lunghezza (cm)*',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Inserisci lunghezza...',
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
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Larghezza (cm)*',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Inserisci larghezza...',
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Altezza (cm)*',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Inserisci altezza...',
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
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _saveOrder,
                backgroundColor: Colors.orange,
                child: Icon(Icons.check, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchOption(String title, bool value, Function(bool) onChanged) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}