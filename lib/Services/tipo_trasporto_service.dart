import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Models/merce_pericolosa_model.dart';
import 'package:flutter_etrucknet_new/Models/tipoTrasporto_model.dart';

class TipoTrasportoService {
  Future<List<TipoTrasporto>> fetchTipiTrasporto() async {
    return [
      TipoTrasporto(id: 1, name: "Merce generica"),
      TipoTrasporto(id: 2, name: "Temperatura positiva"),
      TipoTrasporto(id: 3, name: "Temperatura negativa"),
      TipoTrasporto(id: 4, name: "Trasporto auto"),
      TipoTrasporto(id: 5, name: "ADR merce pericolosa"),
      TipoTrasporto(id: 6, name: "Espressi dedicati"),
      TipoTrasporto(id: 7, name: "Espresso Corriere (plichi-colli)"),
      TipoTrasporto(id: 8, name: "Eccezionali"),
      TipoTrasporto(id: 9, name: "Rifiuti"),
      TipoTrasporto(id: 10, name: "Via mare"),
      TipoTrasporto(id: 11, name: "Via treno"),
      TipoTrasporto(id: 12, name: "Via aereo"),
      TipoTrasporto(id: 13, name: "Intermodale"),
      TipoTrasporto(id: 14, name: "Traslochi"),
      TipoTrasporto(id: 15, name: "Cereali sfusi"),
      TipoTrasporto(id: 16, name: "Farmaci"),
      TipoTrasporto(id: 17, name: "Trasporto imbarcazioni"),
      TipoTrasporto(id: 18, name: "Trasporto pesci vivi"),
      TipoTrasporto(id: 19, name: "Trazioni"),
      TipoTrasporto(id: 20, name: "Noleggio (muletti, ecc.)"),
      TipoTrasporto(id: 21, name: "Sollevamenti (gru, ecc.)"),
      TipoTrasporto(id: 22, name: "Piattaforma distribuzione"),
      TipoTrasporto(id: 23, name: "Operatore doganale"),
      TipoTrasporto(id: 24, name: "Cisternati Chimici"),
      TipoTrasporto(id: 25, name: "Cisternati Carburanti"),
      TipoTrasporto(id: 26, name: "Cisternati alimenti"),
      TipoTrasporto(id: 27, name: "Opere d'arte"),
    ];
  }
  void showTipoTrasportoDialog(BuildContext context, TipoTrasporto tipoTrasporto, double selectedTemperature, double selectedTemperatureN, Function(double) updateTemperature, Function(double) updateTemperatureN) {
    String dialogMessage = "";

    MercePericolosa? selectedMercePericolosa;

    List<String> allestimenti = ["Bancali", "Containers", "Altro"];
    String selectedAllestimento = "Bancali";

    TextEditingController certificazioneController = TextEditingController();

    switch (tipoTrasporto.id) {
      case 2:
        dialogMessage = "Hai selezionato: Temperatura positiva.";
        break;
      case 3:
        dialogMessage = "Hai selezionato: Temperatura negativa.";
        break;
      case 4:
        dialogMessage = "Hai selezionato: Trasporto auto.";
        break;
      case 5:
        dialogMessage = "Hai selezionato: ADR merce pericolosa.";
        break;
      case 9:
        dialogMessage = "Hai selezionato: Rifiuti.";
        break;
      case 10:
        dialogMessage = "Hai selezionato: Via mare.";
        break;
      case 24:
        dialogMessage = "Hai selezionato: Cisternati Chimici.";
        break;
      default:
        dialogMessage = "Hai selezionato: ${tipoTrasporto.name}. Non sono disponibili dettagli aggiuntivi.";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('${tipoTrasporto.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(dialogMessage),
                SizedBox(height: 10),
                if (tipoTrasporto.id == 2) ...[
                  Text("Seleziona la temperatura:"),
                  Slider(
                    thumbColor: Colors.orange,
                    value: selectedTemperature,
                    min: 0.0,
                    max: 15.0,
                    divisions: 15,
                    label: "${selectedTemperature.toStringAsFixed(0)}°C",
                    onChanged: (double newValue) {
                      setState(() {
                        selectedTemperature = newValue;
                      });
                      updateTemperature(newValue);
                    },
                    inactiveColor: Colors.grey,
                    activeColor: Colors.orange,
                  ),
                  Text("Temperatura selezionata: ${selectedTemperature.toStringAsFixed(0)}°C"),
                ],
                if (tipoTrasporto.id == 3) ...[
                  Text("Seleziona la temperatura:"),
                  Slider(
                    thumbColor: Colors.orange,
                    value: selectedTemperatureN,
                    min: -24.0,
                    max: -1.0,
                    divisions: 23,
                    label: "${selectedTemperatureN.toStringAsFixed(0)}°C",
                    onChanged: (double newValue) {
                      setState(() {
                        selectedTemperatureN = newValue;
                      });
                      updateTemperatureN(newValue);
                    },
                    inactiveColor: Colors.grey,
                    activeColor: Colors.orange,
                  ),
                  Text("Temperatura selezionata: ${selectedTemperatureN.toStringAsFixed(0)}°C"),
                ],
                if (tipoTrasporto.id == 4) ...[
                  Text("Seleziona l'allestimento:"),
                  DropdownButton<String>(
                    value: selectedAllestimento,
                    onChanged: null,
                    items: allestimenti.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Text(
                    "Per la tipologia di trasporto indicata non è possibile selezionare allestimenti differenti.",
                    style: TextStyle(
                      color: Colors.orange,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (tipoTrasporto.id == 5) ...[
                  Text("Seleziona la tipologia di merce pericolosa:"),
                  DropdownButton<MercePericolosa>(
                    hint: Text("Seleziona una merce pericolosa"),
                    value: selectedMercePericolosa,
                    onChanged: (MercePericolosa? newValue) {
                      setState(() {
                        selectedMercePericolosa = newValue;
                      });
                    },
                    items: MercePericolosa.mercePericolosaList.map((merce) {
                      return DropdownMenuItem<MercePericolosa>(
                        value: merce,
                        child: Text(merce.descrizioneIt),
                      );
                    }).toList(),
                  ),
                  if (selectedMercePericolosa != null)
                    Text(
                      "Hai selezionato: ${selectedMercePericolosa!.descrizioneIt}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                ],
                if (tipoTrasporto.id == 9) ...[
                  Text(
                    "Indicare la certificazione valida per il trasporto selezionato:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: certificazioneController,
                    decoration: InputDecoration(
                      hintText: "Es. Certificazione rifiuti 2025",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
                if (tipoTrasporto.id == 10 || tipoTrasporto.id == 24) ...[
                  Text("Seleziona l'allestimento:"),
                  DropdownButton<String>(
                    value: selectedAllestimento,
                    onChanged: null,
                    items: allestimenti.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Text(
                    "Per la tipologia di trasporto indicata non è possibile selezionare allestimenti differenti.",
                    style: TextStyle(
                      color: Colors.orange,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Chiudi', style: TextStyle(color: Colors.orange),),
              ),
            ],
          );
        },
      );
    },
  );
  }
}