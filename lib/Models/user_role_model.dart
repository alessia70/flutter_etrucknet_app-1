class RuoloModel {
  final int id; 
  final String nome;
  final List<RuoloModel> ruoli;

  RuoloModel({
    required this.id,
    required this.nome,
    required this.ruoli,
  });

  factory RuoloModel.fromJson(Map<String, dynamic> json) {
    return RuoloModel(
      id: json['id'],
      nome: json['nome'] as String,
      ruoli: (json['anagraficaRoles'] as List)
          .map((role) => RuoloModel.fromJson(role))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'anagraficaRoles': ruoli.map((ruolo) => ruolo.toJson()).toList(),
    };
  }
}
