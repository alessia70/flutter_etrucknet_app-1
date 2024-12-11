import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter_etrucknet_new/Provider/estimates_provider.dart';

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

  void _cancelOrder() {
      Navigator.of(context).pop();
  }
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
            onPressed: () {
              updateEstimate(context, widget.estimate['id']);
            },
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
              Text(
                'Modifica Stima',
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
                      updateEstimate(context, widget.estimate['id']);
                    },
                    child: Text('Aggiorna Stima'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _cancelOrder,
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
  void updateEstimate(BuildContext context, int estimateId) {
    final provider = Provider.of<EstimatesProvider>(context, listen: false);
    Map<String, dynamic> updatedEstimate = {
      'id': estimateId,
      'data': DateTime.now().toIso8601String(),
      'utente': 'Utente A',
      'carico': _tipologiaTrasportoController.text.trim().isNotEmpty
          ? _tipologiaTrasportoController.text.trim()
          : widget.estimate['carico'],
      'scarico': _locationController.text.trim().isNotEmpty
          ? _locationController.text.trim()
          : widget.estimate['scarico'],
      'mezzo': _mezzoController.text.trim().isNotEmpty
          ? _mezzoController.text.trim()
          : widget.estimate['mezzo'],
      'specifiche': _specificheController.text.trim().isNotEmpty
          ? _specificheController.text.trim()
          : widget.estimate['specifiche'],
      'opzioniAggiuntive': _additionalOptionsController.text.trim().isNotEmpty
          ? _additionalOptionsController.text.trim()
          : widget.estimate['opzioniAggiuntive'],
      'dettagliMerce': _dettagliMerceController.text.trim().isNotEmpty
          ? _dettagliMerceController.text.trim()
          : widget.estimate['dettagliMerce'],
      'altreInformazioni': _altreInformazioniController.text.trim().isNotEmpty
          ? _altreInformazioniController.text.trim()
          : widget.estimate['altreInformazioni'],
      'stimato': widget.estimate['stimato'],
    };

    try {
      provider.updateEstimate(estimateId, updatedEstimate);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stima aggiornata con successo!')),
      );

      Navigator.pop(context, updatedEstimate);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante l\'aggiornamento: ${e.toString()}')),
      );
    }
  }
}
