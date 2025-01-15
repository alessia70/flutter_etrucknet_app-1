import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/mezzo_allestimento_model.dart';
import 'package:flutter_etrucknet_new/Models/tipoTrasporto_model.dart';
import 'package:flutter_etrucknet_new/Models/tipo_mezzo_specifiche_model.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:flutter_etrucknet_new/Services/mezzo_allestimento_service.dart';
import 'package:flutter_etrucknet_new/Services/tipo_mezzo_specifiche.dart';
import 'package:flutter_etrucknet_new/Services/tipo_trasporto_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_etrucknet_new/Provider/estimates_provider.dart';

class NuovaStimaScreen extends StatefulWidget {
  const NuovaStimaScreen({super.key});

  @override
  _NuovaStimaScreenState createState() => _NuovaStimaScreenState();
}

class _NuovaStimaScreenState extends State<NuovaStimaScreen> {
  final TipoTrasportoService _service = TipoTrasportoService();
  List<TipoTrasporto> tipiTrasporto = [];
  int? _selectedTrasportoId;
  
  String? _ritiro;
  String? _consegna;
  String? _selectedImballo;
  // ignore: unused_field
  String _altreInfo = '';

  bool _caricataLateralmente = false;
  bool _pagataContrassegno = false;
  bool _problemiViabilita = false;

  double selectedTemperature = 0.0;
  double selectedTemperatureN = -24.0;

  String selectedMercePericolosa = "";

  final TextEditingController _quantitaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _lunghezzaController = TextEditingController();
  final TextEditingController _larghezzaController = TextEditingController();
  final TextEditingController _altezzaController = TextEditingController();
  final TipoMezzoSpecificheService tipoSpecificheService = TipoMezzoSpecificheService();

  final TipoMezzoAllestimentoService _serviceMA = TipoMezzoAllestimentoService();
  List<TipoMezzoAllestimento> tipiMezzoAllestimento = [];
  int? _selectedMezzoAllestimentoId;

  List<TipoMezzoSpecifiche> tipiMezzoSpecifiche = [];
  List<TipoMezzoSpecifiche> specifiche = [];
  TipoMezzoSpecifiche? selectedSpecifica;

  @override
  void initState() {
    super.initState();
  //_loadAllestimenti();
    _fetchTipiTrasporto();
    _loadSpecifiche();
    _fetchTipiMezzoAllestimento();
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
      print('Errore nel recupero dei tipi di trasporto: $e');
    }
  }

  Future<void> _loadSpecifiche() async {
    try {
      final specificheData = await tipoSpecificheService.fetchTipiMezzoSpecifiche();
      setState(() {
        specifiche = specificheData;
      });
    } catch (e) {
      print("Errore nel recupero degli allestimenti: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuova Stima'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const ProfilePage())
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stima il tuo trasporto',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildTipologiaTrasportoField(),
                SizedBox(height: 20),
                _buildLocationField('Ritiro', (value) {
                  setState(() {
                    _ritiro = value;
                  });
                }),
                SizedBox(height: 20),
                _buildLocationField('Consegna', (value) {
                  setState(() {
                    _consegna = value;
                  });
                }),
                SizedBox(height: 20),
                _buildMezzoField(),
                SizedBox(height: 20),
                _buildSpecificheField(),
                SizedBox(height: 20),
                _buildAdditionalOptions(),
                SizedBox(height: 20),
                _buildDettagliMerce(),
                SizedBox(height: 20),
                _buildAltreInformazioni(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _salvaStima,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Invia'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildTipologiaTrasportoField() {
    return Column(
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
        SizedBox(height: 16),
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
                if (_selectedTrasportoId == 2)
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
                if (_selectedTrasportoId == 3)
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
      ],
    );
  }

  Widget _buildLocationField(String title, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.place, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 56,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Inserisci $title',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMezzoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.directions_bus, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              'Mezzo/Allestimenti',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        SizedBox(height: 8),
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
            onChanged: (newValue) {
              setState(() {
                _selectedMezzoAllestimentoId = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSpecificheField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.question_mark_outlined, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              'Ulteriori Specifiche',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        SizedBox(height: 8),
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
              print('Specifica selezionata: ${nuovaSpecifica?.descrizione}');
            },
            icon: Icon(Icons.arrow_drop_down),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }

  Widget _buildSwitchOption(String title, bool value, Function(bool) onChanged) {
    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildDettagliMerce() {
    return ExpansionTile(
      title: Text(
        'Dettagli Merce',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImballoDropdown(),
              SizedBox(height: 16),
              _buildDescrizioneField(),
              SizedBox(height: 16),
              _buildNumericFields(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImballoDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.inventory_2, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              'Tipo di Imballo',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 56,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
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
    );
  }

  Widget _buildDescrizioneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.description, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              'Descrizione',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 56,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Inserisci descrizione',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumericFields() {
    return Column(
      children: [
        _buildSmallNumericField('Quantità (nr)*', _quantitaController),
        SizedBox(height: 16),
        _buildSmallNumericField('Peso Totale (kg)*', _pesoController),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildSmallNumericField('Lunghezza (cm)*', _lunghezzaController)),
            SizedBox(width: 11),
            Expanded(child: _buildSmallNumericField('Larghezza (cm)*', _larghezzaController)),
            SizedBox(width: 11),
            Expanded(child: _buildSmallNumericField('Altezza (cm)*', _altezzaController)),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallNumericField(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 40,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '0',
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildAltreInformazioni() {
    return ExpansionTile(
      title: Text(
        'Altre informazioni utili',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inserisci altre informazioni:',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _altreInfo = value;
                    });
                  },
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Scrivi qui...',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  void _salvaStima() {
    if (_ritiro == null || _consegna == null || _quantitaController.text.isEmpty || _pesoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Compila tutti i campi obbligatori.')),
      );
      return;
    }

    final newEstimate = {
      'data': DateTime.now().toString(),
      'utente': 'Utente A',
      'carico': _ritiro ?? 'N/A', // Valore di default se _ritiro è null
      'scarico': _consegna ?? 'N/A', // Valore di default se _consegna è null
      'quantita': int.tryParse(_quantitaController.text) ?? 0, 
      'peso': double.tryParse(_pesoController.text) ?? 0.0, 
      'lunghezza': double.tryParse(_lunghezzaController.text) ?? 0.0, 
      'larghezza': double.tryParse(_larghezzaController.text) ?? 0.0, 
      'altezza': double.tryParse(_altezzaController.text) ?? 0.0, 
      'stimato': '1000 USD',
    };

    print(newEstimate);

    Provider.of<EstimatesProvider>(context, listen: false).addEstimate(newEstimate);
    Navigator.pop(context); 
  }

}
