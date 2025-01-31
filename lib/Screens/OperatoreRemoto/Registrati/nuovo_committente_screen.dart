import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/profile_info_operatore_screen.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/side_menu.dart';

class NuovoCommittenteScreen extends StatefulWidget {
  const NuovoCommittenteScreen({super.key});

  @override
  _NuovoCommittenteScreenState createState() => _NuovoCommittenteScreenState();
}

class _NuovoCommittenteScreenState extends State<NuovoCommittenteScreen> {
  //String? _selectedEmail;
  bool _welcomeEmail = false;
  bool _showAdditionalEmails = false; 
  bool _showGradimento = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuovo Committente'),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Nazione'),
              _buildTextField('Inserisci Nazione'),
              SizedBox(height: 16.0),
              _buildLabel('Provincia'),
              _buildTextField('Inserisci Provincia'),
              SizedBox(height: 16.0),
              _buildLabel('Ragione Sociale'),
              _buildTextField('Inserisci Ragione Sociale'),
              SizedBox(height: 16.0),
              _buildLabel('Partita IVA'),
              _buildTextField('Inserisci Partita IVA'),
              SizedBox(height: 16.0),
              _buildLabel('Indirizzo'),
              _buildTextField('Inserisci Indirizzo'),
              SizedBox(height: 16.0),
              _buildLabel('CAP'),
              _buildTextField('Inserisci CAP'),
              SizedBox(height: 16.0),
              _buildLabel('Località'),
              _buildTextField('Inserisci Località'),
              SizedBox(height: 16.0),
              _buildRowWithLabels('Telefono', 'Cellulare'),
              SizedBox(height: 16.0),
              _buildRowWithLabels('Nome', 'Cognome'),
              SizedBox(height: 16.0),
              _buildLabel('Email/Username'),
              _buildTextField('Inserisci Email/Username'),
              SizedBox(height: 16.0),
              _buildLabel('Password'),
              _buildTextField('Inserisci Password'),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showAdditionalEmails = !_showAdditionalEmails;
                  });
                },
                child: Text(
                  'Email Aggiuntive',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ),
              if (_showAdditionalEmails) ...[
                SizedBox(height: 8.0),
                _buildLabel('Email 2'),
                _buildTextField('Inserisci Email 2'),
                SizedBox(height: 8.0),
                _buildLabel('Email 3'),
                _buildTextField('Inserisci Email 3'),
                SizedBox(height: 8.0),
                _buildLabel('Email 4'),
                _buildTextField('Inserisci Email 4'),
                SizedBox(height: 16.0),
              ],
              SizedBox(height: 16.0),
              _buildRowWithSmallLabels('Codice Univoco', 'Indirizzo PEC'),
              SizedBox(height: 16.0),
              _buildRowWithSmallLabels('Iscrizione Albo Trasportatori n.', 'Aliquota'),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mail di Benvenuto',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                 Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: _welcomeEmail,
                          onChanged: (value) {
                            setState(() {
                              _welcomeEmail = value;
                            });
                          },
                          activeColor: Colors.orange,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        _welcomeEmail ? 'Sì' : 'No',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showGradimento = !_showGradimento;
                  });
                },
                child: Text(
                  'Dati di Gradimento e Attività',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ),
              if (_showGradimento) ...[
                SizedBox(height: 8.0),
                _buildLabel('Giudizio'),
                _buildTextField('Inserisci Giudizio'),
                SizedBox(height: 16.0),
              ],
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Azione di salvataggio
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                  ),
                  child: Text('Salva'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildRowWithLabels(String label1, String label2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(label1),
              _buildTextField('Inserisci $label1'),
            ],
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(label2),
              _buildTextField('Inserisci $label2'),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildRowWithSmallLabels(String label1, String label2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(label1),
              _buildTextField('Inserisci $label1', isSmall: true),
            ],
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(label2),
              _buildTextField('Inserisci $label2', isSmall: true),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildTextField(String hintText, {bool isSmall = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        ),
        keyboardType: isSmall ? TextInputType.number : TextInputType.text,
      ),
    );
  }
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
