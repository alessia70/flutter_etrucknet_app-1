import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Services/message_provider.dart';
import 'package:provider/provider.dart';
//import 'package:geocoding/geocoding.dart';

class AddMessageScreen extends StatefulWidget {
  const AddMessageScreen({super.key});
  @override
  _AddMessageScreenState createState() => _AddMessageScreenState();
}

class _AddMessageScreenState extends State<AddMessageScreen> {
  final List<String> _userTypes = [
    'Trasportatore>',
    'Committente',
    'Operatore Remoto',
  ];

  final List<String> _vehicleTypes = [
    'Termoregistratore',
    'Doppio piano',
    'Sponda idraulica - sponda caricatrice',
    'Televigilanza',
    'Scambio pallets',
    'Controllo distribuzione peso',
    'Paratia',
    'Copri scopri(per carico dall\'alto)',
    'Gru',
    'Ragno',
    'Alza e abbassa(centina)',
    'Piantana',
    'Porta Coils',
    'Transpallet',
    'Verricello',
    'Rampe',
    'Teli',
  ];

  final List<String> _setupTypes = [
    'Coperta',
    'Coperta o Scoperta',
    'Allestimenti speciali',
    'Temperatura controllata',
  ];

  final List<String> _countries = [
    'Italia',
    'Francia',
    'Germania',
    'Spagna',
  ];

  final List<String> _regions = [
    'Lombardia',
    'Lazio',
    'Sicilia',
    'Veneto',
  ];

  final List<String> _provinces = [
    'Milano',
    'Roma',
    'Palermo',
    'Verona',
  ];

  final List<String> _transportTypes = [
    'Merce pericolosa',
    'Merce normale',
    'Frigorifero',
    'Animali',
  ];

  final List<String?> _selectedValues = List.filled(7, null); // Selezioni iniziali
  final Set<int> _expandedBoxes = <int>{}; // Set per gestire le box espanse

  final TextEditingController _partenzaController = TextEditingController();
  final TextEditingController _arrivoController = TextEditingController();
  final TextEditingController _oggettoController = TextEditingController();
  final TextEditingController _corpoMessaggioController = TextEditingController();

  bool _isBold = false; 
  bool _isItalic = false;
  bool _isUnderlined = false; 

    void _applyFormatting() {
    final String currentText = _corpoMessaggioController.text;

    String newText = currentText;

    if (_isBold) {
      newText = '*$newText*';
    }
    if (_isItalic) {
      newText = '_$newText';
    }
    if (_isUnderlined) {
      newText = '~$newText~';
    }

    _corpoMessaggioController.text = newText;
    _corpoMessaggioController.selection = TextSelection.fromPosition(TextPosition(offset: newText.length));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aggiungi Messaggio'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExpandableBox(0, 'Informazioni', Icons.info, _buildDropdowns()),
            const SizedBox(height: 16),
            _buildExpandableBox(1, 'Tratta', Icons.directions, _buildTrattaFields()),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final oggetto = _oggettoController.text;
                    final corpo = _corpoMessaggioController.text;
                    final partenza = _partenzaController.text;
                    final arrivo = _arrivoController.text;

                    if (oggetto.isNotEmpty && corpo.isNotEmpty && partenza.isNotEmpty && arrivo.isNotEmpty) {
                      final newMessage = {
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'date': DateTime.now().toLocal().toString().split(' ')[0],
                        'object': oggetto,
                        'user_type': _selectedValues[0], // Assicurati di usare i valori corretti
                        'setup_type': _selectedValues[2], // Assicurati di usare i valori corretti
                        'country': _selectedValues[3], // Assicurati di usare i valori corretti
                        'region': _selectedValues[4], // Assicurati di usare i valori corretti
                        'province': _selectedValues[5], // Assicurati di usare i valori corretti
                        'correspondences': corpo, // Puoi decidere se includere il corpo come corrispondenza
                      };

                      // Salva il messaggio tramite il provider
                      Provider.of<MessagesProvider>(context, listen: false).addMessage(newMessage);

                      // Torna alla schermata della griglia dei messaggi
                      Navigator.pop(context, newMessage);
                    } else {
                      // Mostra un messaggio di errore se mancano dati
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Compila tutti i campi')),
                      );
                    }
                  },
                  child: const Text('Invia Messaggio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Annulla'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange),
                    foregroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableBox(int index, String title, IconData icon, Widget child) {
    final isExpanded = _expandedBoxes.contains(index); 

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            leading: Icon(icon, color: Colors.orange),
            trailing: Icon(
              isExpanded ? Icons.arrow_drop_down : Icons.arrow_drop_up,
              color: Colors.orange,
            ),
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedBoxes.remove(index);
                } else {
                  _expandedBoxes.add(index);
                }
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: child,
            ),
        ],
      ),
    );
  }

  Widget _buildDropdowns() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDropdown('Tipologia Utente', 0),
            const SizedBox(width: 16),
            _buildDropdown('Tipologia Automezzo', 1),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDropdown('Tipologia Allestimento', 2),
            const SizedBox(width: 16),
            _buildDropdown('Nazione di Residenza', 3),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDropdown('Regione di Residenza', 4),
            const SizedBox(width: 16),
            _buildDropdown('Provincia di Residenza', 5),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String title, int index) {
     List<String> options;
    switch (index) {
      case 0:
        options = _userTypes; // Lista per "Tipologia Utente"
        break;
      case 1:
        options = _vehicleTypes; // Lista per "Tipologia Automezzo"
        break;
      case 2:
        options = _setupTypes; // Lista per "Tipologia Allestimento"
        break;
      case 3:
        options = _countries; // Lista per "Nazione di Residenza"
        break;
      case 4:
        options = _regions; // Lista per "Regione di Residenza"
        break;
      case 5:
        options = _provinces; // Lista per "Provincia di Residenza"
        break;
      case 6:
        options = _transportTypes; // Lista per "Tipo Trasporto"
        break;
      default:
        options = []; // Default, nel caso non ci siano opzioni definite
    }
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8), // Spazio tra titolo e dropdown
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // Bordo grigio per il dropdown
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline( // Nasconde la riga sottostante
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Container(
                  margin: const EdgeInsets.only(left: 8.0), // Margine a sinistra
                  child: const Text('Seleziona...'),
                ),
                value: _selectedValues[index],
                items: options.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValues[index] = value; // Aggiorna il valore selezionato
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrattaFields() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildTextField(_partenzaController, 'Partenza'),
            ),
            const SizedBox(width: 16), // Spazio tra i campi
            Expanded(
              child: _buildTextField(_arrivoController, 'Arrivo'),
            ),
          ],
        ),
        const SizedBox(height: 16), // Spazio tra le righe
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDropdown('Tipo Trasporto', 6), // Cambia indice per il dropdown
            const SizedBox(width: 16), // Spazio tra i campi
            Expanded(
              child: _buildTextField(_oggettoController, 'Oggetto'),
            ),
          ],
        ),
        const SizedBox(height: 16), // Spazio tra le righe
        _buildMessageBody(), // Aggiunto corpo del messaggio
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8), // Spazio tra titolo e campo di testo
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey), // Bordo grigio per il campo di testo
            ),
            hintText: 'Inserisci $title',
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Corpo del Messaggio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8), // Spazio tra titolo e campo di testo
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildFormattingToolbar(), // Aggiunto toolbar di formattazione
              const SizedBox(height: 0), // Altezza del divider ridotta
              const Divider(), // Divider per separare toolbar dal messaggio
              TextField(
                controller: _corpoMessaggioController,
                maxLines: 5, // Permette di scrivere più righe
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12), // Padding interno
                  hintText: 'Scrivi il tuo messaggio...',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormattingToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            Icons.format_bold,
            size: 18,
            color: _isBold ? Colors.orange : Colors.black, // Cambia colore se attivo
          ),
          onPressed: () {
            setState(() {
              _isBold = !_isBold; // Toggle grassetto
              _applyFormatting(); // Applica la formattazione
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.format_italic,
            size: 18,
            color: _isItalic ? Colors.orange : Colors.black, // Cambia colore se attivo
          ),
          onPressed: () {
            setState(() {
              _isItalic = !_isItalic; // Toggle corsivo
              _applyFormatting(); // Applica la formattazione
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.format_underline,
            size: 18,
            color: _isUnderlined ? Colors.orange : Colors.black, // Cambia colore se attivo
          ),
          onPressed: () {
            setState(() {
              _isUnderlined = !_isUnderlined; // Toggle sottolineato
              _applyFormatting(); // Applica la formattazione
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.format_list_bulleted, size: 18), // Dimensione del bottone
          onPressed: () {
            // Logica per le liste
          },
        ),
        IconButton(
          icon: const Icon(Icons.format_color_text, size: 18), // Dimensione del bottone
          onPressed: () {
            // Logica per cambiare il colore del testo
          },
        ),
      ],
    );
  }
}
