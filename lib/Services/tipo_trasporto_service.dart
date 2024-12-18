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
}
