class RuoloModel {
  final int id; 
  final String nome;
  final List<RuoloModel> ruoli;

  RuoloModel({
    required this.id,
    required this.nome,
    required this.ruoli,
  });

  factory RuoloModel.fromForm(Map<String, dynamic> json) {
    return RuoloModel(
      id: json['id'],
      nome: json['nome'] as String,
      ruoli: (json['anagraficaRoles'] as List)
          .map((role) => RuoloModel.fromForm(role))
          .toList(),
    );
  }

  Map<String, dynamic> toForm() {
    return {
      'id': id,
      'nome': nome,
      'anagraficaRoles': ruoli.map((ruolo) => ruolo.toForm()).toList(),
    };
  }
}
