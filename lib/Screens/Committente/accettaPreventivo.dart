import 'package:flutter/material.dart';

class AccettaPreventivoPage extends StatefulWidget {
  final int quotazioneId;

  AccettaPreventivoPage({required this.quotazioneId});

  @override
  _AccettaPreventivoPageState createState() => _AccettaPreventivoPageState();
}

class _AccettaPreventivoPageState extends State<AccettaPreventivoPage> {
  final _formKey = GlobalKey<FormState>();
  bool accettaCondizioniGenerali = false;
  bool accettaCondizioniStandard = false;
  bool loading = false;

  String ragSocMitt = '';
  String indirizzoMitt = '';
  String capMitt = '';
  String localitaCarico = '';
  String referenteMitt = '';
  String emailMitt = '';
  String telefonoMitt = '';

  String ragSocDest = '';
  String indirizzoDest = '';
  String capDest = '';
  String localitaScarico = '';
  String referenteDest = '';
  String emailDest = '';
  String telefonoDest = '';

  String emailCondivisione = '';
  String pec = '';
  String codiceUnivoco = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accetta Preventivo'),
      ),
      body: Stack(
        children: [
          if (loading)
            Center(
              child: CircularProgressIndicator(),
            ),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riferimenti Carico (Mittente)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Ragione Sociale*'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo obbligatorio'
                        : null,
                    onSaved: (value) => ragSocMitt = value!,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Indirizzo Mittente*'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo obbligatorio'
                        : null,
                    onSaved: (value) => indirizzoMitt = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'CAP Mittente'),
                    onSaved: (value) => capMitt = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Località di carico (non modificabile)',
                    ),
                    enabled: false,
                    initialValue: localitaCarico,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Riferimenti Consegna (Destinatario)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Ragione Sociale*'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo obbligatorio'
                        : null,
                    onSaved: (value) => ragSocDest = value!,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Indirizzo Destinatario*'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo obbligatorio'
                        : null,
                    onSaved: (value) => indirizzoDest = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'CAP Destinatario'),
                    onSaved: (value) => capDest = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Località di scarico (non modificabile)',
                    ),
                    enabled: false,
                    initialValue: localitaScarico,
                  ),
                  SizedBox(height: 16),
                  CheckboxListTile(
                    title: Text(
                        "L'utente accetta le Condizioni Generali standard di Trasporto."),
                    value: accettaCondizioniGenerali,
                    onChanged: (value) {
                      setState(() {
                        accettaCondizioniGenerali = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text(
                        "L'utente accetta specificamente le clausole delle Condizioni Generali standard."),
                    value: accettaCondizioniStandard,
                    onChanged: (value) {
                      setState(() {
                        accettaCondizioniStandard = value!;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              loading = true;
                            });
                            Future.delayed(Duration(seconds: 2), () {
                              setState(() {
                                loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Preventivo Accettato')));
                            });
                          }
                        },
                        child: Text('Accetta Offerta'),
                      ),
                      SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Chiudi'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
