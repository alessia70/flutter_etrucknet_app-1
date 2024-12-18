import 'package:flutter_etrucknet_new/Models/mezzo_allestimento_model.dart';

class TipoMezzoAllestimentoService {
  Future<List<TipoMezzoAllestimento>> fetchTipiMezzoAllestimento() async {
    return [
      TipoMezzoAllestimento(id: 1, name: "Coperta"),
      TipoMezzoAllestimento(id: 2, name: "Scoperta"),
      TipoMezzoAllestimento(id: 3, name: "Coperta o Scoperta"),
      TipoMezzoAllestimento(id: 4, name: "Allestimenti speciali"),
      TipoMezzoAllestimento(id: 5, name: "Temperatura controllata"),
    ];
  }
}
