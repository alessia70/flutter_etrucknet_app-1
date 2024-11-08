import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/Trasportatore/side_menu_t.dart';

class TrattePage extends StatefulWidget {
  @override
  _TrattePageState createState() => _TrattePageState();
}

class _TrattePageState extends State<TrattePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, String>> tratte = [];
  List<Map<String, String>> filteredTratte = [];

  String filterDirezione = 'Entrambi';

  String defaultPartenza = '';
  String defaultDirezione = 'Andata';
  String defaultArrivo = '';
  String defaultAutomezzo = 'Camion 1';
  String defaultServizio = 'Servizio A';
  String defaultMercePericolosa = 'Gas';
  bool defaultAdrMercePericolosa = false;

  bool isMercePericolosaSelected = false;

  @override
  void initState() {
    super.initState();
    filteredTratte = List.from(tratte);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Tratte'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(context),
            SizedBox(height: 16),
            Expanded(child: _buildTratteTable()),
          ],
        ),
      ),
      drawer: SideMenuT(),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Cerca tratte',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.add_box_outlined, color: Colors.orange),
          onPressed: () {
            _showAddTrattaDialog(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.filter_list, color: Colors.grey),
          onPressed: () {
             _showFilterDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildTratteTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lista delle Tratte', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Partenze')),
                      DataColumn(label: Text('Direzione')),
                      DataColumn(label: Text('Arrivi')),
                      DataColumn(label: Text('Automezzi')),
                      DataColumn(label: Text('Servizi')),
                      DataColumn(label: Text('Azioni')),
                    ],
                     rows: filteredTratte.isNotEmpty 
                    ? filteredTratte.map((tratta) {
                        return _buildDataRow(
                          tratta['partenza']!,
                          tratta['direzione']!,
                          tratta['arrivo']!,
                          tratta['automezzo']!,
                          tratta['servizio']!,
                        );
                      }).toList()
                    : [
                        DataRow(cells: [
                          DataCell(Text('Nessuna tratta trovata')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                        ]),
                      ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String partenza, String direzione, String arrivo, String automezzo, String servizio) {
    return DataRow(cells: [
      DataCell(Text(partenza)),
      DataCell(Text(direzione)),
      DataCell(Text(arrivo)),
      DataCell(Text(automezzo)),
      DataCell(Text(servizio)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.orange),
            onPressed: () {
               _showEditTrattaDialog(context, {
                'partenza': partenza,
                'direzione': direzione,
                'arrivo': arrivo,
                'automezzo': automezzo,
                'servizio': servizio,
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.grey),
            onPressed: () {
              setState(() {
                _showDeleteConfirmationDialog(context, partenza, arrivo);
              });
            },
          ),
        ],
      )),
    ]);
  }

  void _showAddTrattaDialog(BuildContext context) {
    String dialogPartenza = defaultPartenza;
    String dialogDirezione = defaultDirezione;
    String dialogArrivo = defaultArrivo;
    String dialogAutomezzo = defaultAutomezzo;
    String dialogServizio = defaultServizio;
    String dialogMercePericolosa = defaultMercePericolosa;
    bool dialogAdrMercePericolosa = defaultAdrMercePericolosa;
    bool dialogIsMercePericolosaSelected = dialogServizio == 'Merce Pericolosa';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.add, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Aggiungi Tratte'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Inserisci dati puntuali:\n'),
                    SizedBox(height: 9),

                    Text('Partenza', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onChanged: (value) => dialogPartenza = value,
                    ),
                    SizedBox(height: 16),
                    Text('Direzione', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: dialogDirezione,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogDirezione = newValue ?? defaultDirezione;
                        });
                      },
                      items: <String>['Andata', 'Ritorno', 'Andata/Ritorno']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),

                    Text('Arrivo', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onChanged: (value) => dialogArrivo = value,
                    ),
                    SizedBox(height: 16),

                    Text('Automezzo', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: dialogAutomezzo,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogAutomezzo = newValue ?? defaultAutomezzo;
                        });
                      },
                      items: <String>['Camion 1', 'Camion 2', 'Camion 3', 'Furgone', 'Auto', 'Camion frigorifero']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Text('Servizi', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: dialogServizio,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogServizio = newValue ?? defaultServizio;
                          dialogIsMercePericolosaSelected = dialogServizio == 'Merce Pericolosa';
                        });
                      },
                      items: <String>['Servizio A', 'Servizio B', 'Servizio C', 'Merce Pericolosa']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),

                    if (dialogIsMercePericolosaSelected) ...[
                      Text('Tipologia Merce Pericolosa', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: dialogMercePericolosa,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setDialogState(() {
                            dialogMercePericolosa = newValue ?? defaultMercePericolosa;
                          });
                        },
                        items: <String>[
                          'Gas',
                          'Liquidi infiammabili',
                          'Polveri',
                          'Materiali corrosivi',
                          'Sostanze tossiche',
                          'Materiali radioattivi'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); 
                  },
                  child: Text('Annulla', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tratte.add({
                        'partenza': dialogPartenza,
                        'direzione': dialogDirezione,
                        'arrivo': dialogArrivo,
                        'automezzo': dialogAutomezzo,
                        'servizio': dialogServizio,
                        'mercePericolosa': dialogIsMercePericolosaSelected ? dialogMercePericolosa : '',
                      });

                      if (filterDirezione == 'Tutte' || 
                          (filterDirezione == 'Entrambi') || 
                            dialogDirezione == filterDirezione) {
                        filteredTratte.add({
                          'partenza': dialogPartenza,
                          'direzione': dialogDirezione,
                          'arrivo': dialogArrivo,
                          'automezzo': dialogAutomezzo,
                          'servizio': dialogServizio,
                        });
                      }

                      defaultPartenza = dialogPartenza;
                      defaultDirezione = dialogDirezione;
                      defaultArrivo = dialogArrivo;
                      defaultAutomezzo = dialogAutomezzo;
                      defaultServizio = dialogServizio;
                      defaultMercePericolosa = dialogMercePericolosa;
                      defaultAdrMercePericolosa = dialogAdrMercePericolosa;
                    });
                    Navigator.pop(context);
                    _showConfirmationDialog(context);
                  },
                  child: Text('Salva'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Filtra Tratte per Direzione'),
              content: DropdownButton<String>(
                value: filterDirezione,
                isExpanded: true,
                onChanged: (String? newValue) {
                  setDialogState(() {
                    filterDirezione = newValue!;
                  });
                },
                items: <String>['Andata', 'Ritorno', 'Entrambi', 'Tutte']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Annulla', style: TextStyle(color: Colors.grey),),
                ),
                ElevatedButton(
                  onPressed: () {
                    _applyFilter();
                    Navigator.pop(context);
                  },
                  child: Text('Applica filtro'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _applyFilter() {
  setState(() {
    if (filterDirezione == 'Tutte') {
      filteredTratte = List.from(tratte);
    } else {
      filteredTratte = tratte.where((tratta) {
        if (filterDirezione == 'Entrambi') {
          return true;
        }
        return tratta['direzione'] == filterDirezione;
      }).toList();
    }
  });
}


  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tratta Aggiunta'),
          content: Text('La tratta è stata aggiunta con successo!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  void _showDeleteConfirmationDialog(BuildContext context, String partenza, String arrivo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conferma eliminazione'),
          content: Text('Sei sicuro di voler eliminare la tratta da $partenza a $arrivo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annulla', style: TextStyle(color: Colors.grey),),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                tratte.removeWhere((tratta) => tratta['partenza'] == partenza && tratta['arrivo'] == arrivo);

                filteredTratte.removeWhere((tratta) => tratta['partenza'] == partenza && tratta['arrivo'] == arrivo);
              });
              Navigator.pop(context);
              _showDeletionConfirmationDialog(context);
            },
              child: Text('Elimina'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeletionConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tratta Eliminata'),
          content: Text('La tratta è stata eliminata con successo!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK', style: TextStyle(color: Colors.orange),),
            ),
          ],
        );
      },
    );
  }

  void _showEditTrattaDialog(BuildContext context, Map<String, String> tratta) {
    String dialogPartenza = tratta['partenza']!;
    String dialogDirezione = tratta['direzione']!;
    String dialogArrivo = tratta['arrivo']!;
    String dialogAutomezzo = tratta['automezzo']!;
    String dialogServizio = tratta['servizio']!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.edit, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Modifica Tratta'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Modifica dati:\n'),
                    SizedBox(height: 16),

                    Text('Partenza', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onChanged: (value) => dialogPartenza = value,
                      controller: TextEditingController(text: dialogPartenza),
                    ),
                    SizedBox(height: 16),

                    Text('Direzione', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: dialogDirezione,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogDirezione = newValue!;
                        });
                      },
                      items: <String>['Andata', 'Ritorno', 'Andata/Ritorno']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),

                    Text('Arrivo', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onChanged: (value) => dialogArrivo = value,
                      controller: TextEditingController(text: dialogArrivo),
                    ),
                    SizedBox(height: 16),

                    Text('Automezzo', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: dialogAutomezzo,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogAutomezzo = newValue!;
                        });
                      },
                      items: <String>['Camion 1', 'Camion 2', 'Camion 3', 'Furgone', 'Auto', 'Camion frigorifero']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Text('Servizi', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: dialogServizio,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          dialogServizio = newValue!;
                        });
                      },
                      items: <String>['Servizio A', 'Servizio B', 'Servizio C', 'Merce Pericolosa']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Annulla', style: TextStyle(color: Colors.grey),),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      int index = tratte.indexWhere((item) => item['partenza'] == tratta['partenza'] && item['arrivo'] == tratta['arrivo']);

                      if (index != -1) {
                        tratte[index] = {
                          'partenza': dialogPartenza,
                          'direzione': dialogDirezione,
                          'arrivo': dialogArrivo,
                          'automezzo': dialogAutomezzo,
                          'servizio': dialogServizio,
                        };
                      }
                      _applyFilter();
                    });

                    Navigator.pop(context);
                  },
                  child: Text('Salva'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
