import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_etrucknet_new/Services/estimates_provider.dart';

class ModificaStimaScreen extends StatefulWidget {
  final Map<String, dynamic> estimate;
  const ModificaStimaScreen({Key? key, required this.estimate}) : super(key: key);

  @override
  _ModificaStimaScreenState createState() => _ModificaStimaScreenState();
}

class _ModificaStimaScreenState extends State<ModificaStimaScreen> {
  final TextEditingController _tipologiaTrasportoController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _mezzoController = TextEditingController();
  final TextEditingController _specificheController = TextEditingController();
  final TextEditingController _additionalOptionsController = TextEditingController();
  final TextEditingController _dettagliMerceController = TextEditingController();
  final TextEditingController _altreInformazioniController = TextEditingController();

  // Initialize the controllers with the data from the estimate
  @override
  void initState() {
    super.initState();
    _tipologiaTrasportoController.text = widget.estimate['carico'] ?? '';
    _locationController.text = widget.estimate['scarico'] ?? '';
    _mezzoController.text = widget.estimate['mezzo'] ?? '';
    _specificheController.text = widget.estimate['specifiche'] ?? '';
    _additionalOptionsController.text = widget.estimate['opzioniAggiuntive'] ?? '';
    _dettagliMerceController.text = widget.estimate['dettagliMerce'] ?? '';
    _altreInformazioniController.text = widget.estimate['altreInformazioni'] ?? '';
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
        title: Text('Modifica Stima'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              updateEstimate(context, widget.estimate['id']);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Modifica Stima',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Fields
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
              // Update button
              ElevatedButton(
                onPressed: () {
                  updateEstimate(context, widget.estimate['id']);
                },
                child: Text('Aggiorna Stima'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Utility function to build a TextField with decoration
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

  // Function to handle the update of the estimate
  void updateEstimate(BuildContext context, int estimateId) {
    final provider = Provider.of<EstimatesProvider>(context, listen: false);

    Map<String, dynamic> updatedEstimate = {
      'id': estimateId,
      'data': DateTime.now().toString(),
      'utente': 'Utente A',
      'carico': _tipologiaTrasportoController.text.isNotEmpty
          ? _tipologiaTrasportoController.text
          : widget.estimate['carico'],
      'scarico': _locationController.text.isNotEmpty
          ? _locationController.text
          : widget.estimate['scarico'],
      'mezzo': _mezzoController.text.isNotEmpty
          ? _mezzoController.text
          : widget.estimate['mezzo'],
      'specifiche': _specificheController.text.isNotEmpty
          ? _specificheController.text
          : widget.estimate['specifiche'],
      'opzioniAggiuntive': _additionalOptionsController.text.isNotEmpty
          ? _additionalOptionsController.text
          : widget.estimate['opzioniAggiuntive'],
      'dettagliMerce': _dettagliMerceController.text.isNotEmpty
          ? _dettagliMerceController.text
          : widget.estimate['dettagliMerce'],
      'altreInformazioni': _altreInformazioniController.text.isNotEmpty
          ? _altreInformazioniController.text
          : widget.estimate['altreInformazioni'],
      'stimato': widget.estimate['stimato'], // Assicura che questo campo sia mantenuto
    };

    try {
      provider.updateEstimate(estimateId, updatedEstimate); // Verifica che il provider lo aggiorni
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stima aggiornata con successo!')),
      );
      Navigator.pop(context, updatedEstimate); // Verifica che l'aggiornamento avvenga prima del confronto
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: ${e.toString()}')),
      );
    }
  }
}
