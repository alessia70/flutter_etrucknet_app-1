class RuoloModel {
  final int id; // ID del ruolo
  final String nome; // Nome del ruolo

  RuoloModel({
    required this.id,
    required this.nome,
  });

  factory RuoloModel.fromJson(Map<String, dynamic> json) {
    return RuoloModel(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
