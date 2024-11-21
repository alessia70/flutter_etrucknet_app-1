import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:flutter_etrucknet_new/Widgets/side_menu.dart';
import 'package:intl/intl.dart';

class ModifyAnagraficaScreen extends StatefulWidget {
  final Map<String, dynamic> anagrafica;

  // Accettiamo i dati dell'anagrafica come parametro
  ModifyAnagraficaScreen({required this.anagrafica});

  @override
  _ModifyAnagraficaScreenState createState() => _ModifyAnagraficaScreenState();
}

class _ModifyAnagraficaScreenState extends State<ModifyAnagraficaScreen> {
  // Variabili per salvare i dati inseriti e precompilati
  late TextEditingController ragioneSocialeController;
  late TextEditingController partitaIVAController;
  late TextEditingController ratingController;
  late TextEditingController indirizzoController;
  late TextEditingController localitaController;
  late TextEditingController capController;
  late TextEditingController ibanController;
  late TextEditingController swiftController;
  late TextEditingController modalitaComunicazioneController;
  late TextEditingController noteController; 
  late TextEditingController attivitaController;
  late TextEditingController nomeAmministratoreController;
  late TextEditingController cognomeAmministratoreController; 
  late TextEditingController nomeUtenteAmministratoreController;

  String livelloInteresse = 'Nessuno';
  String giudizio = 'Nessuno';
  String categoriaAteco = 'Categoria 1';
  String codiceAteco = 'Codice 1';

  DateTime? dataAccettazioneTermini;
  DateTime? dataAccettazioneCondizioni;

  List<Map<String, dynamic>> contatti = [];

  @override
  void initState() {
    super.initState();
    ragioneSocialeController =
        TextEditingController(text: widget.anagrafica['nome']);
    partitaIVAController =
        TextEditingController(text: widget.anagrafica['partitaIVA'] ?? '');
    ratingController = TextEditingController(text: widget.anagrafica['rating'] ?? '');
    indirizzoController = TextEditingController(text: widget.anagrafica['indirizzo'] ?? '');
    localitaController = TextEditingController(text: widget.anagrafica['localita'] ?? '');
    capController = TextEditingController(text: widget.anagrafica['cap'] ?? '');
    ibanController = TextEditingController(text: widget.anagrafica['iban'] ?? '');
    swiftController = TextEditingController(text: widget.anagrafica['swift'] ?? '');
    modalitaComunicazioneController = TextEditingController(text: widget.anagrafica['modalitaComunicazione'] ?? '');
    noteController = TextEditingController(text: widget.anagrafica['note'] ?? '');
    attivitaController = TextEditingController(text: widget.anagrafica['attivita'] ?? '');
    nomeAmministratoreController = TextEditingController(text: widget.anagrafica['nomeAmministratore'] ?? '');
    cognomeAmministratoreController = TextEditingController(text: widget.anagrafica['cognomeAmministratore'] ?? '');
    nomeUtenteAmministratoreController = TextEditingController(text: widget.anagrafica['nomeUtenteAmministratore'] ?? '');
    contatti = List<Map<String, dynamic>>.from(widget.anagrafica['contatti'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifica Anagrafica'),
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
        ],
      ),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              ExpansionTile(
                title: Text('Dati Aziendali'),
                initiallyExpanded: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField('Ragione Sociale', ragioneSocialeController),
                        _buildTextField('Partita IVA', partitaIVAController),
                        _buildTextField('Rating', ratingController),
                        _buildTextField('Indirizzo', indirizzoController),
                        _buildTextField('Località', localitaController),
                        _buildTextField('CAP', capController),
                        _buildTextField('IBAN', ibanController),
                        _buildTextField('Swift', swiftController),
                        _buildTextField('Modalità di Comunicazione', modalitaComunicazioneController),
                      ],
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('Note'),
                initiallyExpanded: false,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNoteField('Note', noteController),
                      ],
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('Contatti'),
                initiallyExpanded: false,
                children: [
                  ...contatti.map((contatto) {
                    return ExpansionTile(
                      title: Text('${contatto['nome']} ${contatto['cognome']}'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextField('Cognome', TextEditingController(text: contatto['cognome'])),
                              _buildTextField('Nome', TextEditingController(text: contatto['nome'])),
                              _buildTextField('Titolo Ruolo', TextEditingController(text: contatto['titoloRuolo'] ?? '')),
                              _buildTextField('Email', TextEditingController(text: contatto['email'] ?? '')),
                              
                              _buildDropdownField(
                                'Invia',
                                contatto['invia'] ?? 'Nessuna',
                                ['Nessuna', 'Trasporti', 'Fatture', 'Entrambe'],
                              ),
                              _buildTextField('Telefono', TextEditingController(text: contatto['telefono'] ?? '')),
                              _buildTextField('Cellulare', TextEditingController(text: contatto['cellulare'] ?? '')),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: _addNewContact,
                      icon: Icon(Icons.add, color: Colors.orange),
                      label: Text(
                        'Aggiungi Contatto',
                        style: TextStyle(color: Colors.orange),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange,
                        side: BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text('Dati Gradimento e Attività'),
                initiallyExpanded: false,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDropdownField(
                          'Livello di Interesse',
                          livelloInteresse,
                          ['Nessuno', 'Alto', 'Medio', 'Basso'],
                        ),
                        _buildDropdownField(
                          'Giudizio',
                          giudizio,
                          ['Nessuno', 'Ottimo', 'Sufficiente', 'Scarso'],
                        ),
                        _buildDropdownField(
                          'Categoria ATECO',
                          categoriaAteco,
                          ['Categoria 1', 'Categoria 2', 'Categoria 3', 'Categoria 4'], 
                        ),
                        _buildDropdownField(
                          'Codice ATECO',
                          codiceAteco,
                          ['Codice 1', 'Codice 2', 'Codice 3', 'Codice 4'],
                        ),
                        _buildTextField('Attività', attivitaController),
                      ],
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('Dati Amministratore'),
                initiallyExpanded: false,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField('Nome Amministratore', nomeAmministratoreController),
                        _buildTextField('Cognome Amministratore', cognomeAmministratoreController),
                        _buildTextField('Nome Utente', nomeUtenteAmministratoreController),
                        _buildDatePickerField(
                          'Data Accettazione Termini',
                          dataAccettazioneTermini,
                          (selectedDate) {
                            setState(() {
                              dataAccettazioneTermini = selectedDate;
                            });
                          },
                        ),
                        _buildDatePickerField(
                          'Data Accettazione Condizioni',
                          dataAccettazioneCondizioni,
                          (selectedDate) {
                            setState(() {
                              dataAccettazioneCondizioni = selectedDate;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formIsValid()) {
                        print("Dati aggiornati");
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Salva Modifiche',
                      style: TextStyle(color: Colors.orange),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange,
                      side: BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  bool _formIsValid() {
    return ragioneSocialeController.text.isNotEmpty;
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildNoteField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: 5,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
  Widget _buildDropdownField(String label, String currentValue, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            onChanged: (newValue) {
              setState(() {
                currentValue = newValue!;
              });
            },
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, DateTime? selectedDate, Function(DateTime?) onDateSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            onDateSelected(pickedDate);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          child: Text(
            selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate) : 'Seleziona Data',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
  void _addNewContact() {
    setState(() {
      contatti.add({
        'cognome': '',
        'nome': '',
        'titoloRuolo': '',
        'email': '',
        'invia': 'Nessuna',
        'telefono': '',
        'cellulare': '',
      });
    });
  }
}
