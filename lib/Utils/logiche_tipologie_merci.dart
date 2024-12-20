import 'package:flutter/material.dart';

class OrderLogic {
  void handleTransportTypeSelection(String transportType, BuildContext context, Function(double)? onTemperatureSelected) {
    if (transportType == 'Temperatura positiva') {
      if (onTemperatureSelected != null) {
        _showPopuptemperatureP(context, onTemperatureSelected);
      }
    } else if (transportType == 'Temperatura negativa') {
      _showPopuptemperatureN(context, onTemperatureSelected!);
    } else if (transportType == 'Trasporto auto') {
      _showPopupTAuto(context);
    } else if (transportType == 'ADR merce pericolosa') {
      _showPopupMerciPericolose(context, fetchMerciP).then((selectedMerci) {
      if (selectedMerci != null) {
        print('Merci selezionate: $selectedMerci');
      }
    });
    } else if (transportType == 'Rifiuti') {
      _showPopup(context, 'Info', 'Hai selezionato un trasporto speciale');
    } else if (transportType == 'Via mare') {
      _showPopup(context, 'Info', 'Hai selezionato un trasporto speciale');
    } else if (transportType == 'Cisternati chimici') {
      _showPopup(context, 'Info', 'Hai selezionato un trasporto speciale');
    } else if (transportType == 'Cisternati carbonati') {
      _showPopup(context, 'Info', 'Hai selezionato un trasporto speciale');
    } else if (transportType == 'Cisternati alimenti') {
      _showPopup(context, 'Info', 'Hai selezionato un trasporto speciale');
    }
  }

  void _showPopuptemperatureP(BuildContext context, Function(double) onTemperatureSelected) {
    double selectedTemperature = 7.5;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.thermostat, color: Colors.orange), 
              SizedBox(width: 8.0),
              Text('Seleziona Temperatura'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Imposta la temperatura desiderata (0-15°C)',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Slider(
                value: selectedTemperature,
                min: 0,
                max: 15,
                divisions: 30, 
                label: '${selectedTemperature.toStringAsFixed(1)} °C',
                onChanged: (value) {
                  selectedTemperature = value;
                },
              ),
              Text(
                '${selectedTemperature.toStringAsFixed(1)} °C',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onTemperatureSelected(selectedTemperature);
              },
              child: Text('Conferma'),
            ),
          ],
        );
      },
    );
  }

  void _showPopuptemperatureN(BuildContext context, Function(double) onTemperatureSelected) {
    double selectedTemperature = 7.5;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.thermostat, color: Colors.orange), 
              SizedBox(width: 8.0),
              Text('Seleziona Temperatura'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Imposta la temperatura desiderata)',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Slider(
                value: selectedTemperature,
                min: -24,
                max: -1,
                divisions: 30, 
                label: '${selectedTemperature.toStringAsFixed(1)} °C',
                onChanged: (value) {
                  selectedTemperature = value;
                },
              ),
              Text(
                '${selectedTemperature.toStringAsFixed(1)} °C',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onTemperatureSelected(selectedTemperature);
              },
              child: Text('Conferma'),
            ),
          ],
        );
      },
    );
  }

  void _showPopupTAuto(BuildContext context) {
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.directions_car, color: Colors.orange),
              SizedBox(width: 8.0),
              Text('Selezione Allestimento'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: null,
                hint: Text('Nessuna selezione disponibile'),
                items: ['Nessuna selezione disponibile']
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: null,
              ),
              SizedBox(height: 16.0),
              Text(
                'Per la tipologia di trasporto indicata non è possibile selezionare allestimenti differenti.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }

  Future<List<String>?> _showPopupMerciPericolose(BuildContext context, Future<List<String>> Function() fetchMerciPericolose) async {
      List<String> merciPericolose = await fetchMerciPericolose();

      Map<String, bool> selezioni = {
        for (var merce in merciPericolose) merce: false,
    };

    return await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8.0),
                  Text('Selezione Merci Pericolose'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var merce in merciPericolose)
                      CheckboxListTile(
                        title: Text(merce),
                        value: selezioni[merce],
                        onChanged: (bool? value) {
                          setState(() {
                            selezioni[merce] = value ?? false;
                          });
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  child: Text('Chiudi'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(selezioni.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList());
                  },
                  child: Text('Conferma'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<String>> fetchMerciP() async {
    await Future.delayed(Duration(seconds: 1));
    return ["Explosivi", "Gas", "Liquidi Infiammabili", "Sostanze Tossiche"];
  }

  void _showPopup(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
