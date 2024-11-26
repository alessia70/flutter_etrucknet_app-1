import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/order_model.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/side_menu.dart';

class EditOrderForm extends StatefulWidget {
  final Order order;

  EditOrderForm({Key? key, required this.order}) : super(key: key);

  @override
  _EditOrderFormState createState() => _EditOrderFormState();
}

class _EditOrderFormState extends State<EditOrderForm> {
  late TextEditingController customerNameController;
  late TextEditingController customerContactController;
  late TextEditingController loadingDateController;
  late TextEditingController unloadingDateController;
  late TextEditingController loadingLocationController;
  late TextEditingController unloadingLocationController;
  late TextEditingController loadingProvinceController;
  late TextEditingController unloadingProvinceController;
  late TextEditingController loadingCountryController;
  late TextEditingController unloadingCountryController;
  late TextEditingController offerAmountController;
  late TextEditingController estimatedBudgetController;
  bool isLoadingMandatory = false;
  bool isUnloadingMandatory = false;
  late String? selectedVehicleType = null;
  late String? selectedAdditionalSpecs = null;
  bool isSideLoading = false;
  bool isCashOnDelivery = false;
  bool hasTrafficRestrictions = false;

  String? selectedPackagingType;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String selectedTransportType = 'Standard';
  final List<String> transportTypes = ['Standard', 'Espresso', 'Furgone'];
  final List<String> vehicleTypes = ['Furgone', 'Camion', 'Rimorchio', 'Cisterna'];
  final List<String> additionalSpecs = ['Refrigerato', 'Telonato', 'Frigorifero', 'Altri'];
  final List<String> packagingTypes = ['Scatola', 'Pallet', 'Container', 'Sacchi'];

  @override
  void initState() {
    super.initState();

    customerNameController = TextEditingController(text: widget.order.customerName);
    customerContactController = TextEditingController(text: widget.order.customerContact);
    loadingDateController = TextEditingController(text: widget.order.loadingDate);
    unloadingDateController = TextEditingController(text: widget.order.unloadingDate);
    loadingLocationController = TextEditingController(text: widget.order.loadingLocation);
    unloadingLocationController = TextEditingController(text: widget.order.unloadingLocation);
    loadingProvinceController = TextEditingController(text: widget.order.loadingProvince);
    unloadingProvinceController = TextEditingController(text: widget.order.unloadingProvince);
    loadingCountryController = TextEditingController(text: widget.order.loadingCountry);
    unloadingCountryController = TextEditingController(text: widget.order.unloadingCountry);
    offerAmountController = TextEditingController(text: widget.order.offerAmount.toString());
    estimatedBudgetController = TextEditingController(text: widget.order.estimatedBudget.toString());

    selectedPackagingType = widget.order.packagingType ?? 'Scatola';
    descriptionController.text = widget.order.description ?? '';
    quantityController.text = widget.order.quantity?.toString() ?? '';
    weightController.text = widget.order.totalWeight?.toString() ?? '';
    lengthController.text = widget.order.length?.toString() ?? '';
    widthController.text = widget.order.width?.toString() ?? '';
    heightController.text = widget.order.height?.toString() ?? '';

    isLoadingMandatory = widget.order.isLoadingMandatory;
    isUnloadingMandatory = widget.order.isUnloadingMandatory;
    selectedVehicleType = widget.order.vehicleType ?? null;
    selectedAdditionalSpecs = widget.order.additionalSpecs ?? null;

  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerContactController.dispose();
    loadingDateController.dispose();
    unloadingDateController.dispose();
    loadingLocationController.dispose();
    unloadingLocationController.dispose();
    loadingProvinceController.dispose();
    unloadingProvinceController.dispose();
    loadingCountryController.dispose();
    unloadingCountryController.dispose();
    offerAmountController.dispose();
    estimatedBudgetController.dispose();
    super.dispose();
  }

  void _saveOrder() {
    final updatedOrder = Order(
      id: widget.order.id,
      customerName: customerNameController.text,
      customerContact: customerContactController.text,
      date: DateTime.now(),
      companyName: widget.order.companyName,
      loadingDate: loadingDateController.text,
      loadingLocation: loadingLocationController.text,
      loadingProvince: loadingProvinceController.text,
      loadingCountry: loadingCountryController.text,
      isLoadingMandatory: widget.order.isLoadingMandatory,
      isUnloadingMandatory: widget.order.isUnloadingMandatory,
      unloadingDate: unloadingDateController.text,
      unloadingLocation: unloadingLocationController.text,
      unloadingProvince: unloadingProvinceController.text,
      unloadingCountry: unloadingCountryController.text,
      offerAmount: double.tryParse(offerAmountController.text) ?? 0.0,
      activeOffers: widget.order.activeOffers,
      expiredOffers: widget.order.expiredOffers,
      correspondenceCount: widget.order.correspondenceCount,
      estimatedBudget: double.tryParse(estimatedBudgetController.text) ?? 0.0,

      vehicleType: selectedVehicleType,
      additionalSpecs: selectedAdditionalSpecs, 
      isCompleted: false, 
      isCanceled: false,
    );
    Navigator.of(context).pop(updatedOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifica Ordine'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const ProfilePage()
                )
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveOrder,
          ),
        ],
      ),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Ordine: ${widget.order.id}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedTransportType,
                decoration: InputDecoration(
                  labelText: 'Tipologia Trasporto',
                  border: OutlineInputBorder(),
                ),
                onChanged: (newValue) {
                  setState(() {
                    selectedTransportType = newValue!;
                  });
                },
                items: transportTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // Row for Loading and Unloading Location
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: loadingLocationController,
                      decoration: InputDecoration(labelText: 'Luogo di Ritiro'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: unloadingLocationController,
                      decoration: InputDecoration(labelText: 'Luogo di Consegna'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Row for Loading and Unloading Dates
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: loadingDateController,
                      decoration: InputDecoration(labelText: 'Data di Ritiro'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: unloadingDateController,
                      decoration: InputDecoration(labelText: 'Data di Consegna'),
                    ),
                  ),
                ],
              ),
               SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Carico tassativo
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Carico Tassativo',
                          style: TextStyle(fontSize: 16),
                        ),
                        Transform.scale(
                          scale: 0.8, // Riduce la dimensione dello switch
                          child: Switch(
                            value: isLoadingMandatory,
                            onChanged: (bool value) {
                              setState(() {
                                isLoadingMandatory = value;
                              });
                            },
                            activeColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16), // Spazio tra i due blocchi

                  // Scarico tassativo
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Scarico Tassativo',
                          style: TextStyle(fontSize: 16),
                        ),
                        Transform.scale(
                          scale: 0.8, // Riduce la dimensione dello switch
                          child: Switch(
                            value: isUnloadingMandatory,
                            onChanged: (bool value) {
                              setState(() {
                                isUnloadingMandatory = value;
                              });
                            },
                            activeColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedVehicleType,
                items: vehicleTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedVehicleType = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tipo Mezzo/Allestimento (opzionale)',
                  border: OutlineInputBorder(),
                ),
              ),
              
              SizedBox(height: 16),

              // Dropdown per ulteriori specifiche
              DropdownButtonFormField<String>(
                value: selectedAdditionalSpecs,
                items: additionalSpecs.map((String spec) {
                  return DropdownMenuItem<String>(
                    value: spec,
                    child: Text(spec),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedAdditionalSpecs = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Ulteriori Specifiche (opzionale)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Switch per Carico laterale
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Carico Lateralmente',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8, // Riduci dimensione dello switch
                          child: Switch(
                            value: isSideLoading,
                            onChanged: (bool value) {
                              setState(() {
                                isSideLoading = value;
                              });
                            },
                            activeColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),

                  // Switch per Contrassegno
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Pagato in Contrassegno',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: isCashOnDelivery,
                            onChanged: (bool value) {
                              setState(() {
                                isCashOnDelivery = value;
                              });
                            },
                            activeColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),

                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Problemi di Viabilità',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: hasTrafficRestrictions,
                            onChanged: (bool value) {
                              setState(() {
                                hasTrafficRestrictions = value;
                              });
                            },
                            activeColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

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
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        value: selectedPackagingType,
                        isExpanded: true,
                        underline: SizedBox(),
                        items: packagingTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedPackagingType = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Descrizione',
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

              // Tabella dei campi Quantità, Peso, Lunghezza, Larghezza, Altezza
              Row(
                children: [
                  // Quantità
                  Expanded(
                    child: TextField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantità',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),

                  // Peso Totale
                  Expanded(
                    child: TextField(
                      controller: weightController,
                      decoration: InputDecoration(
                        labelText: 'Peso Totale (kg)',
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
                children: [
                  // Lunghezza
                  Expanded(
                    child: TextField(
                      controller: lengthController,
                      decoration: InputDecoration(
                        labelText: 'Lunghezza (cm)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),

                  // Larghezza
                  Expanded(
                    child: TextField(
                      controller: widthController,
                      decoration: InputDecoration(
                        labelText: 'Larghezza (cm)',
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
                children: [
                  // Altezza
                  Expanded(
                    child: TextField(
                      controller: heightController,
                      decoration: InputDecoration(
                        labelText: 'Altezza (cm)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: heightController,
                      decoration: InputDecoration(
                        labelText: 'Altezza (cm)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
