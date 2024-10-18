class RuoloModel {
  final int id; 
  final String nome;

  RuoloModel({
    required this.id,
    required this.nome,
  });

  factory RuoloModel.fromJson(Map<String, dynamic> json) {
    return RuoloModel(
      id: json['id'],
      nome: json['nome'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
