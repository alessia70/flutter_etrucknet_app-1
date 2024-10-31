import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/camion_model.dart';

class CamionDisponibiliTPage extends StatefulWidget {
  @override
  _CamionDisponibiliTPageState createState() => _CamionDisponibiliTPageState();
}

class _CamionDisponibiliTPageState extends State<CamionDisponibiliTPage> {
  DateTime? selectedDate;
  final List<Camion> camionList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camion Disponibili'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.info, color: Colors.white),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 16),
            Expanded(child: _buildCamionTable()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCamionDialog(),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Cerca camion',
              labelStyle: TextStyle(color: Colors.orange),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.date_range, color: Colors.orange),
          onPressed: () {
            _selectDate(context);
          },
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildCamionTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tabella dei Camion Disponibili',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Tipo Mezzo')),
                    DataColumn(label: Text('Spazio Disponibile')),
                    DataColumn(label: Text('Luogo Ritiro')),
                    DataColumn(label: Text('Data Ritiro')),
                    DataColumn(label: Text('Località Destinazione')),
                    DataColumn(label: Text('Azioni')),
                  ],
                  rows: camionList.map((camion) => _buildDataRow(camion)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(Camion camion) {
    return DataRow(cells: [
      DataCell(Text(camion.tipoMezzo)),
      DataCell(Text(camion.spazioDisponibile.toString())),
      DataCell(Text(camion.localitaCarico)),
      DataCell(Text(camion.dataRitiro.toLocal().toString().split(' ')[0])),
      DataCell(Text(camion.localitaScarico)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.orange),
            onPressed: () {
              _showEditCamionDialog(camion);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.grey),
            onPressed: () {
              setState(() {
                camionList.remove(camion);
              });
            },
          ),
        ],
      )),
    ]);
  }

   void _showEditCamionDialog(Camion camion) {
    _showCamionDialog(camion);
  }

  void _showAddCamionDialog() {
    _showCamionDialog(null);
  }

  void _showCamionDialog({Camion? camion}) {
    final TextEditingController tipoMezzoController = TextEditingController();
    final TextEditingController spazioDisponibileController = TextEditingController();
    final TextEditingController localitaCaricoController = TextEditingController();
    final TextEditingController localitaScaricoController = TextEditingController();
    DateTime? dataRitiro;
    DateTime? inizioDisponibilita;
    DateTime? fineDisponibilita;
    bool isRecurring = false;
    Map<String, bool> selectedDays = {
      "Lun": false,
      "Mar": false,
      "Mer": false,
      "Gio": false,
      "Ven": false,
      "Sab": false,
      "Dom": false,
    };

    if (camion != null) {
      tipoMezzoController.text = camion.tipoMezzo;
      spazioDisponibileController.text = camion.spazioDisponibile.toString();
      localitaCaricoController.text = camion.localitaCarico;
      dataRitiro = camion.dataRitiro;
      localitaScaricoController.text = camion.localitaScarico;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(camion == null ? 'Aggiungi Camion Disponibile' : 'Modifica Camion Disponibile'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: tipoMezzoController,
                      decoration: InputDecoration(labelText: 'Tipo Automezzo*'),
                    ),
                    TextField(
                      controller: spazioDisponibileController,
                      decoration: InputDecoration(labelText: 'Spazio Lineare disponibile (in cm)*'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: localitaCaricoController,
                      decoration: InputDecoration(labelText: 'Luogo in cui è disponibile*'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: dataRitiro ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setState(() {
                            dataRitiro = picked;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Data Ritiro',
                        suffixIcon: Icon(Icons.date_range, color: Colors.orange),
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: dataRitiro != null ? "${dataRitiro!.toLocal()}".split(' ')[0] : "",
                      ),
                    ),
                    TextField(
                      controller: localitaScaricoController,
                      decoration: InputDecoration(labelText: 'Località di destinazione desiderata*'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Disponibilità Ricorrente"),
                        Switch(
                          activeColor: Colors.orange,
                          value: isRecurring,
                          onChanged: (value) {
                            setState(() {
                              isRecurring = value;
                            });
                          },
                        ),
                      ],
                    ),
                    if (isRecurring) _buildRecurringDaysSelector(selectedDays, setState),
                    SizedBox(height: 16),
                    _buildDateRangePicker("Inizio Disponibilità", inizioDisponibilita, setState, (picked) {
                      setState(() {
                        inizioDisponibilita = picked;
                      });
                    }),
                    SizedBox(height: 16),
                    _buildDateRangePicker("Fine Disponibilità", fineDisponibilita, setState, (picked) {
                      setState(() {
                        fineDisponibilita = picked;
                      });
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (tipoMezzoController.text.isNotEmpty &&
                        spazioDisponibileController.text.isNotEmpty &&
                        localitaCaricoController.text.isNotEmpty &&
                        dataRitiro != null &&
                        localitaScaricoController.text.isNotEmpty &&
                        inizioDisponibilita != null &&
                        fineDisponibilita != null) {
                      try {
                        final int spazioDisponibile = int.parse(spazioDisponibileController.text);
                        final newCamion = Camion(
                          tipoMezzo: tipoMezzoController.text,
                          spazioDisponibile: spazioDisponibile,
                          localitaCarico: localitaCaricoController.text,
                          dataRitiro: dataRitiro!,
                          localitaScarico: localitaScaricoController.text,
                        );
                        setState(() {
                          if (camion == null) {
                            camionList.add(newCamion);
                            print("Camion aggiunto: $newCamion");
                          } else {
                            int index = camionList.indexOf(camion);
                            if (index != -1) {
                              camionList[index] = newCamion;
                              print("Camion aggiornato: $newCamion");
                            }
                          }
                        });
                        Navigator.of(context).pop(); // Chiudi il dialogo
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Il valore di spazio disponibile deve essere un numero valido')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Compila tutti i campi obbligatori')),
                      );
                    }
                  },
                  child: Text(camion == null ? 'Aggiungi' : 'Salva', style: TextStyle(color: Colors.orange)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Annulla', style: TextStyle(color: Colors.grey)),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Widget _buildDateRangePicker(
    String label,
    DateTime? date,
    StateSetter setState,
    Function(DateTime?) onDatePicked,
  ) {
    return TextFormField(
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          onDatePicked(picked);
        }
      },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(Icons.date_range, color: Colors.orange),
        border: OutlineInputBorder(),
      ),
      controller: TextEditingController(
        text: date != null ? "${date.toLocal()}".split(' ')[0] : "",
      ),
    );
  }

  Widget _buildRecurringDaysSelector(Map<String, bool> selectedDays, StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Giorni della Settimana:', style: TextStyle(color: Colors.orange)),
        Wrap(
          spacing: 8.0,
          children: selectedDays.keys.map((day) {
            return FilterChip(
              label: Text(day),
              selected: selectedDays[day]!,
              selectedColor: Colors.orange.shade200,
              onSelected: (bool value) {
                setState(() {
                  selectedDays[day] = value;
                });
              },
            );
          }).toList(),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              selectedDays.updateAll((key, value) => true);
            });
          },
          child: Text("Seleziona Tutti", style: TextStyle(color: Colors.orange)),
        ),
      ],
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informazioni', style: TextStyle(color: Colors.orange)),
          content: Text('Questa è una sezione per aggiungere camion disponibili. Compila i dettagli e premi Aggiungi.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Chiudi', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }
}
