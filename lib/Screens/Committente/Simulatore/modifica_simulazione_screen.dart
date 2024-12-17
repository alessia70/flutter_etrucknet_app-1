import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Provider/estimates_provider.dart';
import 'package:flutter_etrucknet_new/Screens/Committente/side_menu_committente.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:provider/provider.dart';

class ModificaSimulazioneScreen extends StatefulWidget {
  final Map<String, dynamic> simulation;
  const ModificaSimulazioneScreen({Key? key, required this.simulation}) : super(key: key);

  @override
  _ModificaSimulazioneScreenState createState() => _ModificaSimulazioneScreenState();
}

class _ModificaSimulazioneScreenState extends State<ModificaSimulazioneScreen> {
  final TextEditingController _tipologiaTrasportoController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _mezzoController = TextEditingController();
  final TextEditingController _specificheController = TextEditingController();
  final TextEditingController _additionalOptionsController = TextEditingController();
  final TextEditingController _dettagliMerceController = TextEditingController();
  final TextEditingController _altreInformazioniController = TextEditingController();

  void _cancelSimulation() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _tipologiaTrasportoController.text = widget.simulation['carico'] ?? '';
    _locationController.text = widget.simulation['scarico'] ?? '';
    _mezzoController.text = widget.simulation['mezzo'] ?? '';
    _specificheController.text = widget.simulation['specifiche'] ?? '';
    _additionalOptionsController.text = widget.simulation['opzioniAggiuntive'] ?? '';
    _dettagliMerceController.text = widget.simulation['dettagliMerce'] ?? '';
    _altreInformazioniController.text = widget.simulation['altreInformazioni'] ?? '';
  }

  @override
  void dispose() {
    _tipologiaTrasportoController.dispose();
    _locationController.dispose();
    _mezzoController.dispose();
    _specificheController.dispose();
    _additionalOptionsController.dispose();
    _dettagliMerceController.dispose();
    _altreInformazioniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifica Simulazione'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              updateSimulation(context, widget.simulation['id']);
            },
          ),
        ],
      ),
      drawer: SideMenuCommittente(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Modifica Simulazione',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildTextField(_tipologiaTrasportoController, 'Tipologia Trasporto'),
              SizedBox(height: 16),
              _buildTextField(_locationController, 'Location'),
              SizedBox(height: 16),
              _buildTextField(_mezzoController, 'Mezzo'),
              SizedBox(height: 16),
              _buildTextField(_specificheController, 'Specifiche'),
              SizedBox(height: 16),
              _buildTextField(_additionalOptionsController, 'Opzioni Aggiuntive'),
              SizedBox(height: 16),
              _buildTextField(_dettagliMerceController, 'Dettagli Merce'),
              SizedBox(height: 16),
              _buildTextField(_altreInformazioniController, 'Altre Informazioni'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      updateSimulation(context, widget.simulation['id']);
                    },
                    child: Text('Aggiorna Simulazione'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _cancelSimulation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Icon(Icons.close, size: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  void updateSimulation(BuildContext context, int simulationId) {
    final provider = Provider.of<EstimatesProvider>(context, listen: false);

    Map<String, dynamic> updatedSimulation = {
      'id': simulationId,
      'data': DateTime.now().toString(),
      'utente': 'Utente A',
      'carico': _tipologiaTrasportoController.text.isNotEmpty
          ? _tipologiaTrasportoController.text
          : widget.simulation['carico'],
      'scarico': _locationController.text.isNotEmpty
          ? _locationController.text
          : widget.simulation['scarico'],
      'mezzo': _mezzoController.text.isNotEmpty
          ? _mezzoController.text
          : widget.simulation['mezzo'],
      'specifiche': _specificheController.text.isNotEmpty
          ? _specificheController.text
          : widget.simulation['specifiche'],
      'opzioniAggiuntive': _additionalOptionsController.text.isNotEmpty
          ? _additionalOptionsController.text
          : widget.simulation['opzioniAggiuntive'],
      'dettagliMerce': _dettagliMerceController.text.isNotEmpty
          ? _dettagliMerceController.text
          : widget.simulation['dettagliMerce'],
      'altreInformazioni': _altreInformazioniController.text.isNotEmpty
          ? _altreInformazioniController.text
          : widget.simulation['altreInformazioni'],
      'stimato': widget.simulation['stimato'],
    };

    try {
      provider.updateSimulation(simulationId, updatedSimulation);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Simulazione aggiornata con successo!')),
      );
      Navigator.pop(context, updatedSimulation);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: ${e.toString()}')),
      );
    }
  }
}
